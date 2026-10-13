#!/system/bin/sh
# Multi-touch initializer for creek (Redmi 14C / Redmi 15 / POCO M7)

LOGMSG() {
    echo "I:runatboot: $@" >> /tmp/recovery.log
}

load_touch_drivers() {
    local p=/vendor/lib/modules/1.1

    # Важно: xiaomi_touch_game конфликтует с xiaomi_tp (дубликат get_xiaomi_touch_class),
    # из-за чего падают td4376_spi и nt36672s_spi! Если он загружен — выгружаем его.
    if grep -q "^xiaomi_touch_game " /proc/modules 2>/dev/null; then
        rmmod xiaomi_touch_game 2>/dev/null
    fi

    # Базовые зависимости
    for mod in spi-msm-geni lct_tp panel_event_notifier xm_adapter_class miev xiaomi_tp; do
        if ! grep -q "^${mod} " /proc/modules 2>/dev/null; then
            insmod "$p/${mod}.ko" 2>/dev/null
        fi
    done

    # Драйверы тач-панелей для всех возможных экранов creek
    for ts in td4376_spi nt36672s_spi focaltech_ts_i2c goodix_ts_9896; do
        if ! grep -q "^${ts} " /proc/modules 2>/dev/null; then
            insmod "$p/${ts}.ko" 2>/dev/null
        fi
    done

    # Если ни один SPI драйвер не подошел и нужен focaltech/goodix c xiaomi_touch_game:
    if ! grep -q -E "^(td4376_spi|nt36672s_spi) " /proc/modules 2>/dev/null; then
        if ! grep -q -E "^(focaltech_ts_i2c|goodix_ts_9896) " /proc/modules 2>/dev/null; then
            rmmod xiaomi_tp 2>/dev/null
            insmod "$p/xiaomi_touch_game.ko" 2>/dev/null
            insmod "$p/focaltech_ts_i2c.ko" 2>/dev/null
            insmod "$p/goodix_ts_9896.ko" 2>/dev/null
        fi
    fi
}

LOGMSG "Executing universal touch setup..."
load_touch_drivers
LOGMSG "Universal touch setup finished."
exit 0

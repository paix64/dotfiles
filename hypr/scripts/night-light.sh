#!/bin/bash

TEMP=$(busctl --user -- get-property rs.wl-gammarelay /outputs/eDP_1 rs.wl.gammarelay Temperature | awk '{print $2}')

if [ "$TEMP" -eq 6500 ]; then
    busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 3500
else
    busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 6500
fi

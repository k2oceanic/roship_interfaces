# The RawAnalog message represents both a proportional and
# an absolute thrust value
# Voltage shall be computed as follows:
# float voltage = proportional_value * scale

# ID of the analog channel.  analogs may be indexed from one, zero, or randomly selected.
int32   channel_id

uint8   type
uint8   TYPE_VOLTAGE=0
uint8   TYPE_CURRENT=1

# A scale factor that, when multiplied by the proportional_value, yields
# the electic potential in volts.  If this value is not known the scale shall
# be set to 0.0.   This will produce a valid voltage of 0.0 if no checking is
# implemented in software but still allows to us
float32 scale

## A value from -1.0 to 1.0 representing the proportional value of an analog value
float32 proportional_value



# The Thrust message represents a proportional thruster command with an optional
# absolute thrust value.
# Thrust shall be computed as follows:
# float thrust = proportional_value * scale

# ID of the thruster.  thrusters may be indexed from one, zero, or randomly selected.
int32   thruster_id

# A scale factor that, when multiplied by the proportional_value, yields
# the thrust in newtons.  If this value is not known the scale shall
# be set to 0.0.  This will produce a valid thrust of 0.0 if no checking is
# implemented in software but still allows the user to see if the thruster
# is uncalibrated by checking (scale == 0.0)
float32 scale

# A value from -1.0 to 1.0 representing the proportional thruster command
float32 proportional_value
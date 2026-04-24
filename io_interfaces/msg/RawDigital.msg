# The RawDigital message represents a single digital output (DIO) or relay channel.
# The output state is expressed as a boolean on/off value.

# ID of the digital channel.  channels may be indexed from one, zero, or randomly selected.
int32   channel_id

# The commanded state of the digital output.
# True = HIGH / energized / closed (relay)
# False = LOW / de-energized / open (relay)
bool    state

uint8   node_id         # Target node ID (stack position)
int32   channel         # Target channel ID

bool    powered         # Relay on/off (true = energize, false = de-energize)
float32 setpoint        # Setpoint value for proportional relays (0.0 to 1.0)
bool    trip_reset      # Trip reset (true = reset trip, false = no action)


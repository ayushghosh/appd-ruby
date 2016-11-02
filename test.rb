require './appd'

# App settings
config = Appd.newConfig()
Appd.appd_config_init(config)

Appd.set_app_name(config, "My First Ruby App")
Appd.set_tier_name(config, "Ruby")
Appd.set_node_name(config, "Ubuntu")

# Controller settings
Appd.set_controller_host(config, "localhost")
Appd.set_controller_port(config, 8090)
Appd.set_controller_use_ssl(config, 0)
Appd.set_controller_account(config, "customer1")
Appd.set_controller_access_key(config, "fba7e812-28ac-4e55-a841-53cef576a97c")
Appd.set_init_timeout_ms(config, 5000)

Appd.dump_config(config)

rc = Appd.appd_sdk_init(config)
puts "Init #{rc}"
if rc == 0
    # Register a backend
    backendname = "chunkybacon"
    Appd.appd_backend_declare(Appd::APPD_BACKEND_HTTP, backendname)
    rc = Appd.appd_backend_set_identifying_property(backendname, "HOST", "ruby.sky.com")
    if rc != 0
        puts "Failed to set HOST on backend"
    end
    rc = Appd.appd_backend_add(backendname)
    if rc != 0
        puts "Failed to add backend"
    end
    puts "Top of loop"
    1.upto 10 do
        # incoming correlation string as second arg
        bt = Appd.appd_bt_begin("doStuff", "")
        puts "BT started"
        sleep 1
        Appd.appd_bt_add_user_data(bt, "bacon type", "chunky")
        exitcall = Appd.appd_exitcall_begin(bt, backendname)
        # Get correaltion information
        correlation = Appd.appd_exitcall_get_correlation_header(exitcall)
        puts "Correlation #{Appd::APPD_CORRELATION_HEADER_NAME} = #{correlation}"
        puts "> Exit call started"
        sleep 1
        Appd.appd_exitcall_end(exitcall)
        Appd.appd_bt_end(bt)
        puts "BT end"
    end
end

puts "Bye"


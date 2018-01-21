defmodule ServerModule do
    use GenServer
    def start_link(cores, k) do
        args = [cores, k]
        #k = args #String.to_integer(args)
        {:ok, ifs} = :inet.getif()
        ips = for {ip, _, _} <- ifs, do: to_string(:inet.ntoa(ip))
        server_ip = to_string(hd(ips))
        {:ok, server_pid} = GenServer.start_link(__MODULE__, args, [name: :ServerGen])
        #IO.inspect server_pid 
        server_name = "server@" <> server_ip
        Node.start(:"#{server_name}")
        Node.set_cookie :sugar
        actor_pids = spawn_actors(k, cores, [])
        Enum.each(actor_pids, fn(pid) ->
            #IO.puts "In here"
            #IO.inspect pid
            Worker.gen_bitcoins(pid, k, server_pid)
        end )
        :timer.sleep(100000)
        {:ok, actor_pids}
    end
    def init(state) do
        {:ok, state}
    end
    def print_bitcoins(server_pid, bitcoin, pid) do
        #IO.puts "print"
        GenServer.cast(server_pid, {:print_bitcoin, bitcoin, pid})
    end
    #TODO remove pid here
    def handle_cast({:print_bitcoin, bitcoin, pid}, state) do
        bitcoins = []
        Enum.concat(bitcoins, [bitcoin])
        IO.puts bitcoin
        {:noreply, state}
    end
    def spawn_actors(k, number_cores, actor_pids) do
        #IO.puts "server spawn"
        if number_cores == 1 do
            {:ok, pid} = Worker.start_link
            #IO.inspect pid
            actor_pids = Enum.concat([pid], actor_pids)
        else
            {:ok, pid} = Worker.start_link
            #IO.inspect pid
            actor_pids = Enum.concat([pid], actor_pids)
            spawn_actors(k, number_cores - 1, actor_pids)
        end
    end
    def get_k(server, state) do
        GenServer.call(server, :get_k)
    end

    def handle_call(:get_k, _from, state) do
        k = state
        {:reply, k, state}
    end
end

defmodule Client do
    use GenServer
        def start_link(args) do
            [cores, k] = args
            {:ok, client_pid} = GenServer.start_link(__MODULE__ , [])
            actor_pids = spawn_actors(k, cores, [])
            Enum.each(actor_pids, fn(pid) ->
                #IO.puts "In here"
                #IO.inspect pid
                ClientWorker.gen_bitcoins(pid, k, client_pid)
            end )
            :timer.sleep(10000000)
        end
    def print_bitcoins(server_pid, bitcoin, pid) do
        GenServer.cast(server_pid, {:print_bitcoin, bitcoin, pid})
    end
    #TODO remove pid here
    def handle_cast({:print_bitcoin, bitcoin, pid}, state) do
        bitcoins = []
        Enum.concat(bitcoins, [bitcoin])
        #IO.puts inspect(pid) <> bitcoin
        {:noreply, state}
    end
    def spawn_actors(k, number_cores, actor_pids) do
        if number_cores == 1 do
            {:ok, pid} = ClientWorker.start_link
            actor_pids = Enum.concat([pid], actor_pids)
        else
            {:ok, pid} = ClientWorker.start_link
            actor_pids = Enum.concat([pid], actor_pids)
            spawn_actors(k, number_cores - 1, actor_pids)
        end
    end
end

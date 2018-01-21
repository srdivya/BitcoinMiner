defmodule ClientModule do
    use GenServer
    def start_link(args) do
        #server_ip = Enum.at(args,0)
        {:ok, ifs} = :inet.getif()
        ips = for {ip, _, _} <- ifs, do: to_string(:inet.ntoa(ip))
        client_ip = to_string(hd(ips))
        client_name =  "client@" <> client_ip
        Node.start(:"#{client_name}")
        #IO.puts "#{inspect Node.start(:"#{client_name}")}"
        #Node.start :client_name #this is the IP of the machine on which you run the code
        Node.set_cookie :sugar
        server_name = "server@#{args}"
        Node.connect (:"#{server_name}")
        k = ServerModule.get_k(:ServerGen, [])
        params = [10, k]
        Client.start_link(params)
    end
end

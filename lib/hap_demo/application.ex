defmodule HAPDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HAPDemo.Supervisor]

    hap_server_config = %HAP.AccessoryServer{
      name: "My HAP Demo Device",
      identifier: "11:22:33:44:55:66",
      accessory_type: 5,
      accessories: [
        %HAP.Accessory{
          name: "My HAP Lightbulb",
          services: [
            %HAP.Services.LightBulb{on: {HAPDemo.GPIO, gpio_pin: 22}}
          ]
        }
      ]
    }

    children =
      [
        HAPDemo.GPIO,
        {HAP, hap_server_config}
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: HAPDemo.Worker.start_link(arg)
      # {HAPDemo.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: HAPDemo.Worker.start_link(arg)
      # {HAPDemo.Worker, arg},
    ]
  end

  def target() do
    Application.get_env(:hap_demo, :target)
  end
end

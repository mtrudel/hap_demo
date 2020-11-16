defmodule HAPDemo.GPIO do
  @moduledoc """
  Responsible for controlling indicated GPIO pins
  """

  @behaviour HAP.ValueStore

  use GenServer

  require Logger

  def start_link(config) do
    GenServer.start_link(__MODULE__, config, name: __MODULE__)
  end

  @impl HAP.ValueStore
  def get_value(opts) do
    GenServer.call(__MODULE__, {:get, opts})
  end

  @impl HAP.ValueStore
  def put_value(value, opts) do
    GenServer.call(__MODULE__, {:put, value, opts})
  end

  @impl HAP.ValueStore
  def set_change_token(change_token, opts) do
    GenServer.call(__MODULE__, {:set_change_token, change_token, opts})
  end

  def toggle(gpio) do
    GenServer.call(__MODULE__, {:toggle, gpio})
  end

  @impl GenServer
  def init(_) do
    {:ok, gpio} = Circuits.GPIO.open(22, :output)
    {:ok, %{22 => {gpio, nil}}}
  end

  @impl GenServer
  def handle_call({:get, gpio_pin: gpio}, _from, state) do
    value =
      state
      |> Map.get(gpio)
      |> elem(0)
      |> Circuits.GPIO.read()

    Logger.info("Returning value of #{value} for GPIO #{gpio}")

    {:reply, {:ok, value}, state}
  end

  @impl GenServer
  def handle_call({:put, value, gpio_pin: gpio}, _from, state) do
    result =
      state
      |> Map.get(gpio)
      |> elem(0)
      |> Circuits.GPIO.write(value)

    Logger.info("Writing value of #{value} to GPIO #{gpio} (result #{result})")

    {:reply, result, state}
  end

  @impl GenServer
  def handle_call({:set_change_token, change_token, gpio_pin: gpio}, _from, state) do
    state = state |> Map.update!(gpio, fn {gpio, _} -> {gpio, change_token} end)
    {:reply, :ok, state}
  end

  def handle_call({:toggle, gpio_pin}, _from, state) do
    {gpio, change_token} = state |> Map.get(gpio_pin)

    new_value =
      case Circuits.GPIO.read(gpio) do
        0 -> 1
        1 -> 0
      end

    Circuits.GPIO.write(gpio, new_value)

    if !is_nil(change_token) do
      HAP.value_changed(change_token)
    end

    {:reply, :ok, state}
  end
end

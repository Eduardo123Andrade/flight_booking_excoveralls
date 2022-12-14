defmodule FlightBookingExcoveralls.Bookings.AgentTest do
  use ExUnit.Case

  import FlightBookingExcoveralls.Factory

  # alias FlightBookingExcoveralls.Bookings.CreateOrUpdate
  alias FlightBookingExcoveralls.Bookings.Agent, as: BookingAgent

  # alias FlightBookingExcoveralls.Users.Agent, as: UserAgent

  describe "save/1" do
    test "saves the flight booking" do
      booking = build(:booking)

      BookingAgent.start_link(%{})

      assert BookingAgent.save(booking) == :ok
    end
  end

  describe "get/1" do
    setup do
      BookingAgent.start_link()
      :ok
    end

    test "when the booking is found, return the booking" do
      booking = build(:booking)

      BookingAgent.save(booking)

      response = BookingAgent.get(booking.id)
      expected_response = {:ok, booking}

      assert response == expected_response
    end

    test "when the booking is not found, return an error" do
      wrong_id = UUID.uuid4()

      :booking
      |> build
      |> BookingAgent.save()

      response = BookingAgent.get(wrong_id)
      expected_response = {:error, "Booking not found"}

      assert response == expected_response
    end
  end

  describe "get_all/0" do
    test "List all bookings" do
      BookingAgent.start_link()

      :booking
      |> build()
      |> BookingAgent.save()

      response =
        BookingAgent.get_all()
        |> Enum.count()

      expected_response = 1

      assert expected_response == response
    end
  end
end

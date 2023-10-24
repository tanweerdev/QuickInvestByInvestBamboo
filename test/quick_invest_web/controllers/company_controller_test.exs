defmodule QuickInvestWeb.CompanyControllerTest do
  use QuickInvestWeb.ConnCase

  alias QuickInvest.Events.Store
  alias QuickInvest.Events.Event

  setup %{conn: conn} do
    Enum.each(mocked_companies(), &Store.add/1)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all companies", %{conn: conn} do
      conn = get(conn, ~p"/api/companies")

      assert json_response(conn, 200)["data"] == [
               %{"category" => "real_estate", "enabled" => true, "name" => "D"},
               %{"category" => "technology", "enabled" => false, "name" => "C"},
               %{"category" => "finance", "enabled" => true, "name" => "B"},
               %{"category" => "technology", "enabled" => true, "name" => "A"}
             ]
    end
  end

  describe "filter" do
    test "lists filtered enabled companies", %{conn: conn} do
      conn = get(conn, ~p"/api/companies?enabled=true")

      assert json_response(conn, 200)["data"] == [
               %{"category" => "real_estate", "enabled" => true, "name" => "D"},
               %{"category" => "finance", "enabled" => true, "name" => "B"},
               %{"category" => "technology", "enabled" => true, "name" => "A"}
             ]
    end

    test "lists filtered technology companies", %{conn: conn} do
      conn = get(conn, ~p"/api/companies?category=technology")

      assert json_response(conn, 200)["data"] == [
               %{"category" => "technology", "enabled" => false, "name" => "C"},
               %{"category" => "technology", "enabled" => true, "name" => "A"}
             ]
    end

    test "lists filtered finance companies", %{conn: conn} do
      conn = get(conn, ~p"/api/companies?category=finance")

      assert json_response(conn, 200)["data"] == [
               %{"category" => "finance", "enabled" => true, "name" => "B"}
             ]
    end

    test "lists filtered real_estate companies", %{conn: conn} do
      conn = get(conn, ~p"/api/companies?category=real_estate")

      assert json_response(conn, 200)["data"] == [
               %{"category" => "real_estate", "enabled" => true, "name" => "D"}
             ]
    end

    test "lists filtered enabled and technology companies", %{conn: conn} do
      conn = get(conn, ~p"/api/companies?category=technology&enabled=true")

      assert json_response(conn, 200)["data"] == [
               %{"category" => "technology", "enabled" => true, "name" => "A"}
             ]
    end
  end

  defp mocked_companies() do
    [
      %Event{
        id: 1,
        company_name: "A",
        category: :technology,
        enabled: true
      },
      %Event{
        id: 2,
        company_name: "B",
        category: :finance,
        enabled: true
      },
      %Event{
        id: 3,
        company_name: "C",
        category: :technology,
        enabled: false
      },
      %Event{
        id: 4,
        company_name: "D",
        category: :real_estate,
        enabled: true
      }
    ]
  end
end

defmodule GameWeb.ReadingLiveTest do
  use GameWeb.ConnCase

  import Phoenix.LiveViewTest
  import Game.LibraryFixtures
  import Game.AccountsFixtures

  @create_attrs %{name: "some name", text: "some text", steps: 42}
  @update_attrs %{name: "some updated name", text: "some updated text", steps: 43}
  @invalid_attrs %{name: nil, text: nil, steps: nil}

  defp create_reading(_) do
    reading = reading_fixture()
    %{reading: reading}
  end

  defp login(%{conn: conn}) do
    %{conn: log_in_user(conn, user_fixture())}
  end

  describe "Index" do
    setup [:create_reading, :login]

    test "lists all readings", %{conn: conn, reading: reading} do
      {:ok, _index_live, html} = live(conn, ~p"/readings")

      assert html =~ "Listing Readings"
      assert html =~ reading.name
    end

    test "saves new reading", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/readings")

      assert index_live |> element("a", "New Reading") |> render_click() =~
               "New Reading"

      assert_patch(index_live, ~p"/readings/new")

      assert index_live
             |> form("#reading-form", reading: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#reading-form", reading: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/readings")

      html = render(index_live)
      assert html =~ "Reading created successfully"
      assert html =~ "some name"
    end

    test "updates reading in listing", %{conn: conn, reading: reading} do
      {:ok, index_live, _html} = live(conn, ~p"/readings")

      assert index_live |> element("#readings-#{reading.id} a", "Edit") |> render_click() =~
               "Edit Reading"

      assert_patch(index_live, ~p"/readings/#{reading}/edit")

      assert index_live
             |> form("#reading-form", reading: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#reading-form", reading: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/readings")

      html = render(index_live)
      assert html =~ "Reading updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes reading in listing", %{conn: conn, reading: reading} do
      {:ok, index_live, _html} = live(conn, ~p"/readings")

      assert index_live |> element("#readings-#{reading.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#readings-#{reading.id}")
    end
  end

  describe "Show" do
    setup [:create_reading, :login]

    test "displays reading", %{conn: conn, reading: reading} do
      {:ok, _show_live, html} = live(conn, ~p"/readings/#{reading}")

      assert html =~ "Show Reading"
      assert html =~ reading.name
    end

    test "updates reading within modal", %{conn: conn, reading: reading} do
      {:ok, show_live, _html} = live(conn, ~p"/readings/#{reading}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Reading"

      assert_patch(show_live, ~p"/readings/#{reading}/show/edit")

      assert show_live
             |> form("#reading-form", reading: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#reading-form", reading: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/readings/#{reading}")

      html = render(show_live)
      assert html =~ "Reading updated successfully"
      assert html =~ "some updated name"
    end
  end
end

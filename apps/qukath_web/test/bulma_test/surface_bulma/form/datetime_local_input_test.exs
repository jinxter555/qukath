defmodule Surface.Components.Form.DateTimeLocalInputTest do
  use SurfaceBulma.ConnCase, async: true

  alias SurfaceBulma.Form.DateTimeLocalInput

  test "empty input" do
    html =
      render_surface do
        ~F"""
        <DateTimeLocalInput form="order" field="completed_at" />
        """
      end

    assert html =~ """
           <input id="order_completed_at" name="order[completed_at]" type="datetime-local">
           """
  end

  test "setting the value" do
    html =
      render_surface do
        ~F"""
        <DateTimeLocalInput form="order" field="completed_at" value="2020-05-05T19:30" />
        """
      end

    assert html =~ """
           <input id="order_completed_at" name="order[completed_at]" type="datetime-local" value="2020-05-05T19:30">
           """
  end

  test "setting the class" do
    html =
      render_surface do
        ~F"""
        <DateTimeLocalInput form="order" field="completed_at" class="input"/>
        """
      end

    assert html =~ ~r/class="input"/
  end

  test "setting multiple classes" do
    html =
      render_surface do
        ~F"""
        <DateTimeLocalInput form="order" field="completed_at" class="input primary"/>
        """
      end

    assert html =~ ~r/class="input primary"/
  end

  test "passing other options" do
    html =
      render_surface do
        ~F"""
        <DateTimeLocalInput form="order" field="completed_at" opts={autofocus: "autofocus"} />
        """
      end

    assert html =~ """
           <input autofocus="autofocus" id="order_completed_at" name="order[completed_at]" type="datetime-local">
           """
  end

  test "events with parent live view as target" do
    html =
      render_surface do
        ~F"""
        <DateTimeLocalInput form="order" field="completed_at" value="2020-05-05T19:30" click="my_click" />
        """
      end

    assert html =~ ~s(phx-click="my_click")
  end

  test "setting id and name through props" do
    html =
      render_surface do
        ~F"""
        <DateTimeLocalInput form="user" field="birth" id="birthday" name="birthday" />
        """
      end

    assert html =~ """
           <input id="birthday" name="birthday" type="datetime-local">
           """
  end

  test "setting the phx-value-* values" do
    html =
      render_surface do
        ~F"""
        <DateTimeLocalInput form="user" field="birth" values={a: "one", b: :two, c: 3} />
        """
      end

    assert html =~ """
           <input id="user_birth" name="user[birth]" phx-value-a="one" phx-value-b="two" phx-value-c="3" type="datetime-local">
           """
  end
end

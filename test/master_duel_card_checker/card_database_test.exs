defmodule MasterDuelCardChecker.CardDatabaseTest do
  use MasterDuelCardChecker.DataCase

  alias MasterDuelCardChecker.CardDatabase

  describe "cards" do
    alias MasterDuelCardChecker.CardDatabase.Card

    import MasterDuelCardChecker.CardDatabaseFixtures

    @invalid_attrs %{mdm_data: nil, ycg_booster: nil, ycg_data: nil}

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert CardDatabase.list_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert CardDatabase.get_card!(card.id) == card
    end

    test "get_card_by_name!/1 returns the card with given name" do
      card = card_fixture()
      assert {:ok, CardDatabase.get_card_by_name(card.ycg_data["name"])} == {:ok, card}
    end

    test "create_card/1 with valid data creates a card" do
      valid_attrs = %{
        name: "some name",
        mdm_data: %{},
        ycg_booster: ["option1", "option2"],
        ycg_data: %{}
      }

      assert {:ok, %Card{} = card} = CardDatabase.create_card(valid_attrs)
      assert card.mdm_data == %{}
      assert card.ycg_booster == ["option1", "option2"]
      assert card.ycg_data == %{}
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CardDatabase.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()

      update_attrs = %{
        name: "some updated name",
        mdm_data: %{},
        ycg_booster: ["option1"],
        ycg_data: %{}
      }

      assert {:ok, %Card{} = card} = CardDatabase.update_card(card, update_attrs)
      assert card.mdm_data == %{}
      assert card.ycg_booster == ["option1"]
      assert card.ycg_data == %{}
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = CardDatabase.update_card(card, @invalid_attrs)
      assert card == CardDatabase.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = CardDatabase.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> CardDatabase.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = card_fixture()
      assert %Ecto.Changeset{} = CardDatabase.change_card(card)
    end
  end
end

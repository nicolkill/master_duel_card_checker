defmodule MasterDuelCardChecker.CardDatabase do
  @moduledoc """
  The CardDatabase context.
  """

  import Ecto.Query, warn: false
  alias MasterDuelCardChecker.Repo

  alias MasterDuelCardChecker.CardDatabase.Card

  defimpl Jason.Encoder, for: Card do
    def encode(value, opts) do
      Jason.Encode.map(Map.drop(value, [:__meta__, :__struct__]), opts)
    end
  end

  defp card_query_paginated(page) do
    size = 100
    offset = page * size

    Card
    |> limit(^size)
    |> offset(^offset)
    |> order_by(asc: :name)
  end

  @doc """
  Returns the list of cards.

  ## Examples

      iex> list_cards()
      [%Card{}, ...]

  """
  def list_cards(page \\ 0) do
    page
    |> card_query_paginated()
    |> Repo.all()
  end

  @spec list_cards_by_booster(String.t(), integer()) :: [%Card{}]
  def list_cards_by_booster(booster, page \\ 0) do
    page
    |> card_query_paginated()
    |> where([c], ^booster in c.ycg_booster)
    |> Repo.all()
  end

  @spec list_cards_by_booster(String.t(), integer()) :: [%Card{}]
  def list_cards_by_not_sync(page \\ 0) do
    page
    |> card_query_paginated()
    |> where([c], is_nil(c.mdm_data))
    |> Repo.all()
  end

  @doc """
  Gets a single card.

  Raises `Ecto.NoResultsError` if the Card does not exist.

  ## Examples

      iex> get_card!(123)
      %Card{}

      iex> get_card!(456)
      ** (Ecto.NoResultsError)

  """
  def get_card!(id), do: Repo.get!(Card, id)

  def get_card_by_name(name) do
    card =
      Card
      |> where(name: ^name)
      |> Repo.one()

    case card do
      nil ->
        %Card{
          name: name,
          ycg_booster: [],
          ycg_data: nil,
          mdm_data: nil
        }

      card ->
        card
    end
  end

  @doc """
  Creates a card.

  ## Examples

      iex> create_card(%{field: value})
      {:ok, %Card{}}

      iex> create_card(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_card(attrs \\ %{}) do
    %Card{}
    |> Card.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a card.

  ## Examples

      iex> update_card(card, %{field: new_value})
      {:ok, %Card{}}

      iex> update_card(card, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_card(%Card{} = card, attrs) do
    card
    |> Card.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a card.

  ## Examples

      iex> delete_card(card)
      {:ok, %Card{}}

      iex> delete_card(card)
      {:error, %Ecto.Changeset{}}

  """
  def delete_card(%Card{} = card) do
    Repo.delete(card)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking card changes.

  ## Examples

      iex> change_card(card)
      %Ecto.Changeset{data: %Card{}}

  """
  def change_card(%Card{} = card, attrs \\ %{}) do
    Card.changeset(card, attrs)
  end
end

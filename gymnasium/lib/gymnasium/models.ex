defmodule Gymnasium.Models do
  @moduledoc """
  The Models context.
  """

  import Ecto.Query, warn: false

  alias Gymnasium.Dimensions.{Model, ModelAttribute, ModelAssociation}
  alias Gymnasium.Repo

  @doc """
  Returns the list of models.

  ## Examples

      iex> list_models()
      [%Model{}, ...]

  """
  def list_models() do
    query = from m in Model, order_by: [asc: m.name]

    Repo.all(query)
  end

  @doc """
  Returns the list of model attributes.

  ## Examples

      iex> list_model_attributes()
      [%ModelAttribute{}, ...]

  """
  def list_model_attributes() do
    query = from m in ModelAttribute, order_by: [asc: m.name]

    Repo.all(query)
  end

  @doc """
  Returns the list of model associations.

  ## Examples

      iex> list_model_associations()
      [%ModelAssociation{}, ...]

  """
  def list_model_associations() do
    query = from m in ModelAssociation, order_by: [asc: m.name]

    Repo.all(query)
  end

  @doc """
  Creates a model association.

  ## Options

      * `:preload_associated_model` - return Model association with preloaded
      associated Model.

  ## Examples

      iex> create_model_association(%{field: value})
      {:ok, %model{}}

      iex> create_model_association(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_model_association(attrs \\ %{}) do
    {:ok, model_association} =
      %ModelAssociation{}
      |> ModelAssociation.changeset(attrs)
      |> Repo.insert()

    model_association =
      if attrs[:preload_associated_model] do
        Repo.preload(model_association, :associated_model)
      else
        model_association
      end

    {:ok, model_association}
  end
end

defmodule UnirisCore.P2P.Message.TransactionInputList do
  @moduledoc """
  Represents a message with a list of transaction inputs
  """
  defstruct [:inputs]

  @type t() :: %__MODULE__{
          inputs: list(UnirisCore.TransactionInput.t())
        }
end

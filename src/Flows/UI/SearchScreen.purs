module Flows.UI.SearchScreen where

import Prelude

import Control.Monad.Eff.Exception (Error)
import Data.Generic.Rep (class Generic)
import Data.Foreign.Class (class Decode, class Encode)
import Data.Foreign.Generic (defaultOptions, genericDecode, genericEncode)
import Presto.Core.Utils.Encoding (defaultDecode, defaultEncode)
import Presto.Core.Types.Language.Interaction (class Interact, defaultInteract)

import Product.Types (SearchTerm)

data SearchScreen       = SearchScreen
data SearchScreenAction = SearchTermEntered SearchTerm

------------------------------------
------------- instances ------------
------------------------------------
instance searchScreenInteract :: Interact Error SearchScreen SearchScreenAction where
  interact x = defaultInteract x

-- to encode screen to JSON
derive instance genericSearchScreen :: Generic SearchScreen _
instance ecodegenericSearchScreen :: Encode SearchScreen where
  encode = genericEncode (defaultOptions {unwrapSingleConstructors = false})

-- to decode screen from JSON
derive instance genericSearchScreenAction :: Generic SearchScreenAction _
instance encodegenericSearchScreenAction :: Decode SearchScreenAction where
  decode = genericDecode (defaultOptions {unwrapSingleConstructors = false})

module Flows.UI.ResultsScreen where

import Prelude (bind, pure, ($))
import Control.Monad.Eff.Exception (Error)
import Data.Foreign.Class (class Decode, class Encode)
import Data.Generic.Rep (class Generic)
import Data.Foreign.Generic (defaultOptions, genericDecode, genericEncode)
import Presto.Core.Types.Language.Interaction (class Interact, defaultInteract)

import Product.Types (Podcast)

data ResultsScreen       = ResultsScreen (Array Podcast)
data ResultsScreenAction = ResultsDisplayed | MakeNewSearch

------------------------------------
------------- instances ------------
------------------------------------
instance resultsScreenInteract :: Interact Error ResultsScreen ResultsScreenAction where
  interact x = defaultInteract x

-- to encode screen to JSON
derive instance genericResultsScreen       :: Generic ResultsScreen _
instance encodegenericResultsScreen :: Encode ResultsScreen where
  encode = genericEncode (defaultOptions {unwrapSingleConstructors = false})

-- to decode screen from JSON
derive instance genericResultsScreenAction :: Generic ResultsScreenAction _
instance decodegenericResultsScreenAction :: Decode ResultsScreenAction where
  decode = genericDecode (defaultOptions {unwrapSingleConstructors = false})

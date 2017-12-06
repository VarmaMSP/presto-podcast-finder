module Product.App where

import Prelude

import Data.Either (Either(..))
import Presto.Core.Types.API (ErrorPayload(..), Response(..))
import Presto.Core.Types.Language.Flow (Flow, runUI)

import Utils.Commons (logAny)
import Product.Types (Podcast)
import Flows.UI.SearchScreen (SearchScreen(..), SearchScreenAction(..))
import Flows.UI.ResultsScreen (ResultsScreen(..), ResultsScreenAction(..))
import Flows.API.FetchPodcasts (fetchPodcasts, FetchPodcastsResult(..))

appFlow :: Flow Unit
appFlow = searchScreenFlow

searchScreenFlow :: Flow Unit
searchScreenFlow = do
  (SearchTermEntered searchTerm) <- runUI SearchScreen
  response                       <- fetchPodcasts searchTerm
  case response of
    Right (FetchPodcastsResult podcasts) -> resultsScreenFlow podcasts
    Left err                             -> handleError err

resultsScreenFlow :: Array Podcast -> Flow Unit
resultsScreenFlow podcasts = void $ do
  resultsScreenAction <- runUI $ ResultsScreen podcasts
  case resultsScreenAction of
    ResultsDisplayed -> pure unit
    MakeNewSearch    -> searchScreenFlow

handleError :: Response ErrorPayload -> Flow Unit
handleError (Response {response: ErrorPayload {errorMessage: error, userMessage: user}}) =
  pure $ logAny error

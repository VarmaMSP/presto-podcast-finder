module Product.App where

import Prelude

import Data.Either (Either(..))
import Data.Array (slice)
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
    Right (FetchPodcastsResult podcasts) -> resultsScreenFlow podcasts 0
    Left err                             -> handleError err

resultsScreenFlow :: Array Podcast -> Int -> Flow Unit
resultsScreenFlow podcasts -1     = pure unit
resultsScreenFlow podcasts 8      = pure unit
resultsScreenFlow podcasts pageNo = void $ do
  let from = pageNo * 14
  let to   = from + 14
  resultsScreenAction <- runUI $ ResultsScreen (slice from to podcasts)
  case resultsScreenAction of
    ResultsDisplayed -> pure unit
    MakeNewSearch    -> searchScreenFlow
    NextPage         -> resultsScreenFlow podcasts (pageNo + 1)
    PrevPage         -> resultsScreenFlow podcasts (pageNo - 1)


handleError :: Response ErrorPayload -> Flow Unit
handleError (Response {response: ErrorPayload {errorMessage: error, userMessage: user}}) =
  pure $ logAny error

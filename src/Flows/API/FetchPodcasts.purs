module Flows.API.FetchPodcasts where

import Prelude

import Data.Either (Either(..), either)
import Data.Foreign.Class (class Decode, class Encode)
import Data.Generic.Rep (class Generic)
import Data.Foreign.Generic (defaultOptions, genericDecode, genericEncode)
import Presto.Core.Types.API (class RestEndpoint, Method(POST), defaultDecodeResponse, defaultMakeRequest, Header(..), Headers(..))
import Presto.Core.Types.Language.Flow (Flow, APIResult)
import Presto.Core.Utils.Encoding (defaultDecode, defaultEncode)
import Presto.Core.Flow (callAPI)
import Presto.Core.Types.Language.Flow (Flow)

import Utils.Commons (logAny)
import Product.Types (Podcast(..), SearchTerm)

newtype FetchPodcastsResult = FetchPodcastsResult (Array Podcast)

newtype FetchPodcastsResponse = FetchPodcastsResponse
  { code     :: Int
  , status   :: String
  , response :: FetchPodcastsResult
  }

newtype FetchPodcastsRequest = FetchPodcastsRequest
  { term   :: SearchTerm
  , limit  :: Number
  , entity :: String
  }

---------------------------------------------------------------
---------- Instances to encode and decode above types ---------
---------------------------------------------------------------
instance fetchPodcastsAPI :: RestEndpoint FetchPodcastsRequest FetchPodcastsResponse where
  makeRequest req headers = defaultMakeRequest POST "/search" headers req
  decodeResponse body     = defaultDecodeResponse body

derive instance genericFetchPodcastsRequest :: Generic FetchPodcastsRequest _
instance decodeFetchPodcastsRequest :: Decode FetchPodcastsRequest where
  decode = genericDecode (defaultOptions {unwrapSingleConstructors = true})
instance encodeFetchPodcastsRequest :: Encode FetchPodcastsRequest where
  encode = genericEncode (defaultOptions {unwrapSingleConstructors = true})

derive instance genericFetchPodcastsResponse :: Generic FetchPodcastsResponse _
instance decodeFetchPodcastsResponse :: Decode FetchPodcastsResponse where
  decode = genericDecode (defaultOptions {unwrapSingleConstructors = true})
instance encodeFetchPodcastsResponse :: Encode FetchPodcastsResponse where
  encode = genericEncode (defaultOptions {unwrapSingleConstructors = true})

derive instance genericFetchPodcastsResult :: Generic FetchPodcastsResult _
instance decodeFetchPodcastsResult :: Decode FetchPodcastsResult where
  decode = genericDecode (defaultOptions {unwrapSingleConstructors = true})
instance encodeFetchPodcastsresult :: Encode FetchPodcastsResult where
  encode = genericEncode (defaultOptions {unwrapSingleConstructors = true})


fetchPodcasts :: SearchTerm -> Flow (APIResult FetchPodcastsResult)
fetchPodcasts t = do
  let request = FetchPodcastsRequest {term : t, limit : 14.0, entity : "podcast"}
  let headers = Headers [Header "Content-Type" "application/json"]
  response    <- callAPI headers request

  case response of
    Left err                                     -> pure $ Left err
    Right (FetchPodcastsResponse {response : x}) -> pure $ Right x

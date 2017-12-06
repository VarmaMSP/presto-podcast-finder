module Product.Types where

import Data.Foreign.Class (class Encode, class Decode)
import Data.Foreign.Generic (defaultOptions, genericEncode, genericDecode)
import Data.Generic.Rep (class Generic)

type SearchTerm = String
newtype Podcast = Podcast { title :: String
                          , link :: String
                          , imageSrc :: String
                          }

derive instance genricPodcast :: Generic Podcast _
instance encodePodcast :: Encode Podcast where
  encode = genericEncode (defaultOptions {unwrapSingleConstructors = true})
instance decodePodcast :: Decode Podcast where
  decode = genericDecode (defaultOptions {unwrapSingleConstructors = true})

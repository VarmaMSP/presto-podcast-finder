module Main where

import Prelude

import Control.Monad.Aff (Aff, Canceler, launchAff, makeAff)
import Control.Monad.Aff.AVar (makeVar')
import Control.Monad.Eff (Eff, kind Effect)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Eff.Exception (EXCEPTION)
import Control.Monad.Aff.AVar (AVAR)
import Control.Monad.State.Trans (evalStateT)
import Data.Either (Either(..))
import Data.Function.Uncurried (runFn2)
import Data.StrMap (empty)
import Presto.Core.Flow (APIRunner, Flow, PermissionRunner(..), Runtime(..), UIRunner, run)
import Presto.Core.Types.App (LOCAL_STORAGE, NETWORK, STORAGE, UI)
import Presto.Core.Types.Permission (Permission, PermissionResponse, PermissionStatus(..))

import Utils.Commons (callAPI', mkNativeRequest, showUI')
import Product.App (appFlow)

foreign import data TIMER :: Effect

type AppEffects = (
    avar :: AVAR
  , exception :: EXCEPTION
  , exception :: EXCEPTION
  , ui :: UI
  , storage :: STORAGE
  , ls :: LOCAL_STORAGE
  , console :: CONSOLE
  , network :: NETWORK
  , timer :: TIMER)

type CancelerEffects = (
	  avar :: AVAR
  , ui :: UI
  , storage :: STORAGE
  , ls :: LOCAL_STORAGE
  , exception :: EXCEPTION
  , network :: NETWORK
  , console :: CONSOLE
  , timer :: TIMER)

launchApp :: Eff (AppEffects) (Canceler (CancelerEffects))
launchApp = do
  let runtime = Runtime uiRunner permissionRunner apiRunner
  let freeFlow = evalStateT(run runtime appFlow)

  launchAff $ makeVar' empty >>= freeFlow
  where
    uiRunner :: UIRunner
    uiRunner a = makeAff (\err sc -> runFn2 showUI' sc a)

    permissionRunner :: PermissionRunner
    permissionRunner = PermissionRunner defaultPermissionStatus defaultPermissionRequest

    apiRunner :: APIRunner
    apiRunner request = makeAff (\err sc -> callAPI' err sc (mkNativeRequest request))

defaultPermissionStatus :: forall e. Array Permission -> Aff (storage :: STORAGE | e) PermissionStatus
defaultPermissionStatus permissions = makeAff (\err sc -> sc PermissionGranted)

defaultPermissionRequest :: forall e. Array Permission -> Aff (storage :: STORAGE | e) (Array PermissionResponse)
defaultPermissionRequest permissions = makeAff (\err sc -> sc [])

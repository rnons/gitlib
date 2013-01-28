{-# LANGUAGE OverloadedStrings #-}

module Git.Libgit2.Tag where

import           Git.Libgit2.Common
import           Git.Libgit2.Internal
import qualified Data.Text as T
import qualified Prelude

data Tag = Tag { tagInfo :: Base Tag
               , tagRef  :: Oid }

instance Show Tag where
  show x = case gitId (tagInfo x) of
    Pending _ -> "Tag..."
    Stored y  -> "Tag#" ++ show y

-- Tag.hs
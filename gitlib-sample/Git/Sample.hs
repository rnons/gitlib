{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

{-# OPTIONS_GHC -fno-warn-name-shadowing
                -fno-warn-unused-binds
                -fno-warn-orphans #-}

module Git.Sample
       ( SampleRepository(..), Repository(..)
       , Git.Oid(..), BlobOid(), TreeOid(), CommitOid()
       , Tree(), Commit()
       , TreeRef(), CommitRef(), Reference()
       , sampleFactory
       , sampleGet
       ) where

import           Control.Applicative
import           Control.Monad.IO.Class
import           Control.Monad.Trans.Class
import           Control.Monad.Trans.Reader
import           Filesystem.Path.CurrentOS as F
import           Prelude hiding (FilePath)
import qualified Git

data Void

instance Git.MonadGit m => Git.Repository (SampleRepository m) where
    data Oid (SampleRepository m)      = Oid Void
    data TreeData (SampleRepository m) = Void
    data Options (SampleRepository m)  = Options

    facts = return Git.RepositoryFacts
        { Git.hasSymbolicReferences = True }

    parseOid         = undefined
    renderOid        = undefined
    lookupRef        = undefined
    createRef        = undefined
    updateRef        = undefined
    deleteRef        = undefined
    resolveRef       = undefined
    allRefNames      = undefined
    lookupCommit     = undefined
    lookupTree       = undefined
    lookupBlob       = undefined
    lookupTag        = undefined
    lookupObject     = undefined
    existsObject     = undefined
    pushCommit       = undefined
    traverseCommits  = undefined
    missingObjects   = undefined
    traverseObjects  = undefined
    newTree          = undefined
    hashContents     = undefined
    createBlob       = undefined
    createCommit     = undefined
    createTag        = undefined
    deleteRepository = undefined
    remoteFetch      = undefined

instance Show (Git.Oid (SampleRepository m)) where
    show (Oid _coid) = undefined

instance Ord (Git.Oid (SampleRepository m)) where
    Oid _coid1 `compare` Oid _coid2 = undefined

instance Eq (Git.Oid (SampleRepository m)) where
    oid1 == oid2 = oid1 `compare` oid2 == EQ

-- type TreeEntry m = Git.TreeEntry (SampleRepository m)

data Repository = Repository Void

instance Eq Repository where
  _x == _y = undefined

instance Show Repository where
  show _x = undefined

newtype SampleRepository m a = SampleRepository
    { sampleRepositoryReaderT :: ReaderT Repository m a }
    deriving (Functor, Applicative, Monad, MonadIO, MonadTrans)

type BlobOid m   = Git.BlobOid (SampleRepository m)
type TreeOid m   = Git.TreeOid (SampleRepository m)
type CommitOid m = Git.CommitOid (SampleRepository m)
--type TagOid m    = Git.TagOid (SampleRepository m)

type Tree m      = Git.Tree (SampleRepository m)
type Commit m    = Git.Commit (SampleRepository m)

type TreeRef m   = Git.TreeRef (SampleRepository m)
type CommitRef m = Git.CommitRef (SampleRepository m)

type Reference m = Git.Reference (SampleRepository m) (Commit m)

sampleGet :: Monad m => SampleRepository m Repository
sampleGet = SampleRepository ask

sampleFactory :: Git.MonadGit m
              => Git.RepositoryFactory SampleRepository m Repository
sampleFactory = Git.RepositoryFactory
    { Git.openRepository  = openSampleRepository
    , Git.runRepository   = runSampleRepository
    , Git.closeRepository = closeSampleRepository
    , Git.getRepository   = sampleGet
    , Git.defaultOptions  = defaultSampleOptions
    , Git.startupBackend  = return ()
    , Git.shutdownBackend = return ()
    }

openSampleRepository :: Git.MonadGit m => Git.RepositoryOptions -> m Repository
openSampleRepository _opts = undefined

runSampleRepository :: Git.MonadGit m
                    => Repository -> SampleRepository m a -> m a
runSampleRepository repo action =
    runReaderT (sampleRepositoryReaderT action) repo

closeSampleRepository :: Git.MonadGit m => Repository -> m ()
closeSampleRepository = const (return ())

defaultSampleOptions :: Git.RepositoryOptions
defaultSampleOptions = Git.RepositoryOptions F.empty False False

-- Sample.hs

.. Structure conventions
     # with overline, for parts
     * with overline, for chapters
     = for sections
     - for subsections
     ^ for subsections
     " for paragraphs

.. _get-the-code:

************
Get the code
************

.. |date| date::

Last Updated on |date|

The `asap` development model recommends the use of the `Fork and pull model
<https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/getting-started/about-collaborative-development-models#fork-and-pull-model>`_
of github projects.

.. note::
  :class: margin

  If you want to create a new repository from the contents of an existing repository but don't want
  to merge your changes to the upstream in the future, you can duplicate the repository or, if the
  repository is a template, you can use the repository as a template. For more information, see
  "`Duplicating a repository <https://docs.github.com/en/articles/duplicating-a-repository>`_" and
  "`Creating a repository from a template
  <https://docs.github.com/en/articles/creating-a-repository-from-a-template>`_".

A fork is a copy of a repository that you manage. Forks let you make changes to a project without
affecting the original repository. You can fetch updates from or submit changes to the original
repository with pull requests. This will give you total freedom to change the code after the way you
want, while still keeping the option to pull updates from the original `asap` project or to
contribute useful changes or bug fixes in the form of pull requests to the original `asap` project.

In the remainder of this guide, we will follow the `Fork and pull model`.

1. Fork the `asap` project
==========================

.. hint::
  :class: margin

  The `asap` project is located at `https://github.com/abdes/asap`.

Follow the instructions described in the `Fork a repo
<https://docs.github.com/en/get-started/quickstart/fork-a-repo>`_ documentation of GitHub to fork
the `asap` project.

.. important:: 

  Rename your fork to match your project name as early as possible in the process. Although you can
  do this step at any time in the future, it is recommended to do it immediately after the fork.

  Follow the instructions described in `Renaming a repository
  <https://docs.github.com/en/get-started/quickstart/fork-a-repo>`_ document from the GitHub
  documentation.

Configuring a remote for the fork
---------------------------------

You must configure a remote that points to the upstream `asap` repository in Git to sync changes
made in the original repository with your fork. This also allows you to sync bug fixes and
enhancements you make in your fork with the original `asap` repository in the form of submitted pull
requests.

#. List the current configured remote repository for your fork.

   .. code:: bash

     $ git remote -v
     > origin  https://github.com/YOUR_USERNAME/YOUR_FORK.git (fetch)
     > origin  https://github.com/YOUR_USERNAME/YOUR_FORK.git (push)

2. Specify a new remote upstream repository that will be synced with the fork.

   .. code:: bash

     $ git remote add upstream https://github.com/abdes/asap.git

3. Verify the new upstream repository you've specified for your fork.

   .. code:: bash

     $ git remote -v
       > origin    https://github.com/YOUR_USERNAME/YOUR_FORK.git (fetch)
       > origin    https://github.com/YOUR_USERNAME/YOUR_FORK.git (push)
       > upstream  https://github.com/abdes/asap.git (fetch)
       > upstream  https://github.com/abdes/asap.git (push)

2. Clone your fork
==================

.. tip:: 
  :class: margin

  -j4 requests git to parallelize cloning of repos. Needs a relatively recent version of git. If
  that is not available, simply do not use this option.

The `asap` project makes use of git submodules. There is a simple way to get the project and the
submodules (populated) in one step. If you pass --recurse-submodules to the git clone command, it
will automatically initialize and update each submodule in the repository, including nested
submodules if any of the submodules in the repository have submodules themselves. You can refer to
the `Git Submodules <https://git-scm.com/book/en/v2/Git-Tools-Submodules>`_ documentation for more
details.

.. code:: bash

  git clone --recurse-submodules -j4 https://github.com/YOUR_USERNAME/YOUR_FORK.git

If you already cloned the project and forgot --recurse-submodules, you can combine the git submodule
init and git submodule update steps by running ```git submodule update --init```. To also initialize,
fetch and checkout any nested submodules, you can use the foolproof ```git submodule update --init
--recursive```.

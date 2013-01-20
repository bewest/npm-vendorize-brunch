## preprocessor-brunch

Easy include/require in Coffeescript to write less code.<br>
It's not intrusive, so you can always use the normal way:

```coffeescript

MyModule = require 'modules/my_module-module'
@require modules.robot
# ModuleRobot = require 'modules/robot-module'

class MyModule
# module.exports = class MyModule

```

## Usage

Add `"preprocessor-brunch": "x.y.z"` to `package.json` of your brunch app.

## App inclusion

Example of use:

```coffeescript

@require application
# Application = require 'application'

# if you prefer to specify the variable name
mediator = @require mediator
# mediator = require 'mediator'

# the module filename are automatically suffixed
@require controller.posts
# PostsController = require 'controllers/posts-controller'
@require view.post
# PostView = require 'views/post-view'
@require view.post.avatar
# PostAvatarView = require 'views/post/avatar-view'
@require collectionView.posts
# PostsCollectionView = require 'views/posts-collection-view'

# the model don't have suffix
@require model.post
# Post = require 'models/post'

# you may just want to include a module
@include helper.view
# require 'helpers/view-helper'

# you may want to put your modules in a subfolder
@require template.spinner
# SpinnerTemplate = require 'views/templates/spinner'

# the file are loaded even with shortcut
@require template.album
# AlbumTemplate = require 'views/album/template/album'
@require view.album
# AlbumView = require 'views/album/album-view'
@require view.album.slider
# AlbumSliderView = require 'views/album/slider/slider-view'

# you could also specify a variable name for conveniency
template = @require template.album
# template = require 'views/album/template/album'

```

## Vendor inclusion

The vendor include/require are the same but the path are not checked.
Be aware that the path will be used to generate the variable name, so you may want to specify them.

```coffeescript

# automatic variable naming based on module path
$require chaplin
# Chaplin = require 'chaplin'
$require chaplin/lib/router
# ChaplinLibRouter = require 'chaplin/lib/router'

# you can, like the app module, specify the variable name
ChaplinRouter = $require chaplin.lib.router
# ChaplinRouter = require 'chaplin/lib/router'
Dispatcher = $require chaplin.dispatcher
# Dispatcher = require 'chaplin/dispatcher'

```

## Types Configuration

If you want to add types:

```coffeescript

types:
	factory:
		path: 'factories'
		suffix: '-factory'
		extension: 'js'
	module:
		path: 'modules'

@require factory.notification
# NotificationFactory = require 'factories/notification-factory'

@require module.robot
# RobotModule = require 'modules/robot'

```

Of course, you may want to edit existing types:

```coffeescript

types:
	controller:
		path: 'app-controllers'
	template:
		path: 'theme/awesome/template'
		extension: 'mustache'

```

Configurated types:

* controller
* view
* model
* collectionView
* template
* helper
* config
* lib

Available type options:

```coffeescript

	# main folder of the type
	# the field is required
	path: 'controllers'

	# filename suffix
	# for example, want you require controller.posts,
	# the file controllers/posts-controller will be used
	# default value: null
	suffix: '-controller'

	# subfolder of the type
	# default value: null
	subFolder: null

	# file extension
	# default value: coffee
	# this field is required
	extension: 'coffee'

	# generate the variable name from the filename
	# for example, for the lib modules,
	# you don't want LibDispatcher, you'd want:
	# Dispatcher = require 'lib/dispatcher'
	# default value: no
	varNameWithFilename: no

	# generate the variable name without the type suffixed
	# for example, it's better to have Post rather than PostModel
	# default value: no
	varNameWithoutType: no

```

## Naming configuration

Maybe you don't want to use @require or @include:

```coffeescript

naming:
	require: '~'
	include: '-'
	prefixApp: '!'
	prefixVendor: '$'

!~ controllers.post
# PostController = require 'controllers/post'
!- helper.view
# require 'helpers/view-helper'

```

```coffeescript

naming:
	require: 'import'
	include: 'include'
	prefixApp: ''
	prefixVendor: 'vendor_'

import controllers.post
# PostController = require 'controllers/post'
include helper.view
# require 'helpers/view-helper'
vendor_import chaplin
# Chaplin = require 'chaplin'

```

## Module exportation configuration

```coffeescript

# prefix all class definition by the defined string
# set to null to disable
# the string that will prefix the class definition
export: 'module.exports = '

```
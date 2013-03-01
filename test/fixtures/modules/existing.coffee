module.exports = [
  {
    isVendor: no
    location: 'controller.base'
    path: 'controllers/base-controller'
    varName: 'BaseController'
  }
  {
    isVendor: no
    location: 'controller.album'
    path: 'controllers/album-controller'
    varName: 'AlbumController'
  }
  {
    isVendor: no
    location: 'view.album'
    path: 'views/album/album-view'
    varName: 'AlbumView'
  }
  {
    isVendor: no
    location: 'collectionView.albums'
    path: 'views/albums-collection-view'
    varName: 'AlbumsCollectionView'
  }
  {
    isVendor: no
    location: 'view.album.slider'
    path: 'views/album/slider/slider-view'
    varName: 'AlbumSliderView'
  }
  {
    isVendor: no
    location: 'template.album.slider'
    path: 'views/album/slider/templates/slider'
    varName: 'AlbumSliderTemplate'
  }
  # vendor
  {
    isVendor: yes
    location: 'jquery'
    varName: 'Jquery'
  }
  {
    isVendor: yes
    location: 'chaplin'
    varName: 'Chaplin'
  }
  {
    isVendor: yes
    location: 'chaplin/lib/router'
    varName: 'ChaplinLibRouter'
  }
]

ToolbarView = null
ToolbarButtonView = null
$$ = null

module.exports =
  toolbarView: null

  activate: (state) ->
    ToolbarView ?= require './toolbar-view'
    @toolbarView = new ToolbarView(state.toolbarViewState)

    ToolbarButtonView ?= require './toolbar-button-view'

    {$$} = require 'atom'

  deactivate: ->
    @toolbarView.destroy()

  serialize: ->
    toolbarViewState: @toolbarView.serialize()

  config:
    position:
      type: 'string'
      default: 'Top'
      enum: ['Top', 'Right', 'Bottom', 'Left']

    visible:
      type: 'boolean'
      default: true

    iconSize:
      type: 'string'
      default: '24px'
      enum: ['16px', '24px']

  prepareButton: (icon, callback, tooltip, iconset) ->
    iconClass = if !iconset then 'icon-' + icon else iconset + '-' + icon

    button = $$ ->
      @div class: 'icon ' + iconClass, title: tooltip

    button.on 'click', =>
      if typeof(callback) == 'string'
        atom.workspaceView.trigger callback
      else
        callback()

    button

  prependButton: (icon, callback, tooltip=null, iconset=null) ->
    button = new ToolbarButtonView icon, callback, tooltip, iconset
    @toolbarView.prepend button
    button

  prependSpacer: (view) ->
    @toolbarView.prepend $$ ->
      @div class: 'spacer'

  appendButton: (icon, callback, tooltip=null, iconset=null) ->
    button = new ToolbarButtonView icon, callback, tooltip, iconset
    @toolbarView.append button
    button

  appendSpacer: (view) ->
    @toolbarView.append $$ ->
      @div class: 'spacer'

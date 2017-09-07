MetalanguageView = require './metalanguage-view'
{CompositeDisposable} = require 'atom'

module.exports = Metalanguage =
  metalanguageView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @metalanguageView = new MetalanguageView(state.metalanguageViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @metalanguageView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'metalanguage:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @metalanguageView.destroy()

  serialize: ->
    metalanguageViewState: @metalanguageView.serialize()

  toggle: ->
    console.log 'Metalanguage was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

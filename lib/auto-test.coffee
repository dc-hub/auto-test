AutoTestView = require './auto-test-view'
{CompositeDisposable} = require 'atom'

module.exports = AutoTest =
  autoTestView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @autoTestView = new AutoTestView(state.autoTestViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @autoTestView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'auto-test:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @autoTestView.destroy()

  serialize: ->
    autoTestViewState: @autoTestView.serialize()

  toggle: ->
    console.log 'AutoTest was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

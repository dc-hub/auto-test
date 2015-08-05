AutoTest = require '../lib/auto-test'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "AutoTest", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('auto-test')

  describe "when the auto-test:toggle event is triggered", ->
    it "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.auto-test')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'auto-test:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.auto-test')).toExist()

        autoTestElement = workspaceElement.querySelector('.auto-test')
        expect(autoTestElement).toExist()

        autoTestPanel = atom.workspace.panelForItem(autoTestElement)
        expect(autoTestPanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'auto-test:toggle'
        expect(autoTestPanel.isVisible()).toBe false

    it "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.auto-test')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'auto-test:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        autoTestElement = workspaceElement.querySelector('.auto-test')
        expect(autoTestElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'auto-test:toggle'
        expect(autoTestElement).not.toBeVisible()

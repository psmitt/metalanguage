Metalanguage = require '../lib/metalanguage'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Metalanguage", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('metalanguage')

  describe "when the metalanguage:toggle event is triggered", ->
    it "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.metalanguage')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'metalanguage:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.metalanguage')).toExist()

        metalanguageElement = workspaceElement.querySelector('.metalanguage')
        expect(metalanguageElement).toExist()

        metalanguagePanel = atom.workspace.panelForItem(metalanguageElement)
        expect(metalanguagePanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'metalanguage:toggle'
        expect(metalanguagePanel.isVisible()).toBe false

    it "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.metalanguage')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'metalanguage:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        metalanguageElement = workspaceElement.querySelector('.metalanguage')
        expect(metalanguageElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'metalanguage:toggle'
        expect(metalanguageElement).not.toBeVisible()

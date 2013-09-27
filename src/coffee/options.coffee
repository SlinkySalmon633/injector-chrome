# [Script Runner](http://neocotic.com/script-runner)  
# (c) 2013 Alasdair Mercer  
# Freely distributable under the MIT license

# TODO: Capture more analytics

# Extract the models and collections that are required by the options page.
{ EditorSettings, EditorSettings, Script, Scripts } = models

# Utilities
# ---------

# Extend `_` with our utility functions.
_.mixin

  # Transform the given string into title case.
  capitalize: (str) ->
    return str unless str

    str.replace /\w+/g, (word) ->
      word[0].toUpperCase() + word[1..].toLowerCase()

# Feedback
# --------

# Indicate whether the user feedback feature has been added to the page.
feedbackAdded = no

# Add the user feedback feature to the page using the `options` provided.
loadFeedback = (options) ->
  # Only load and configure the feedback widget once.
  return if feedbackAdded

  # Create a script element to load the UserVoice widget.
  uv       = document.createElement 'script'
  uv.async = 'async'
  uv.src   = "https://widget.uservoice.com/#{options.id}.js"
  # Insert the script element into the DOM.
  script = document.getElementsByTagName('script')[0]
  script.parentNode.insertBefore uv, script

  # Configure the widget as it's loading.
  UserVoice = window.UserVoice or= []
  UserVoice.push [
    'showTab'
    'classic_widget'
    {
      mode:          'full'
      primary_color: '#333'
      link_color:    '#08c'
      default_mode:  'feedback'
      forum_id:      options.forum
      tab_label:     i18n.get 'feedback_button'
      tab_color:     '#333'
      tab_position:  'middle-left'
      tab_inverted:  yes
    }
  ]

  # Ensure that the widget isn't loaded again.
  feedbackAdded = yes

# Editor
# ------

# View containing buttons for saving/resetting the code of the active script from the contents of
# the Ace editor.
EditorControls = Backbone.View.extend

  el: '#editor_controls'

  events:
    'click #reset_button':  'reset'
    'click #update_button': 'save'

  render: ->
    do @update

    this

  reset: (e) ->
    return if $(e.currentTarget).hasClass('disabled') or not @model?

    @options.ace.setValue @model.get 'code'
    @options.ace.gotoLine 0

  save: (e) ->
    $button = $ e.currentTarget

    return if $button.hasClass('disabled') or not @model?

    code = @options.ace.getValue()

    @model.save({ code }).then =>
      @model.trigger 'modified', no, code

      $button.html(i18n.get 'update_button_alt').delay(800).queue ->
        $button.html(i18n.get 'update_button').dequeue()

  update: (@model) ->
    $buttons = @$ '#reset_button, #update_button'

    if @model?
      $buttons.removeClass 'disabled'
    else
      $buttons.addClass 'disabled'

# A selection of available modes/languages that are supported by this extension for executing
# scripts.
EditorModes = Backbone.View.extend

  el: '#editor_modes'

  template: _.template '<option value="<%- value %>"><%= html %></option>'

  events:
    'change': 'updateMode'

  render: ->
    _.each options.config.editor.modes, (mode) =>
      @$el.append @template
        html:  i18n.get "editor_mode_#{mode}"
        value: mode

    do @update

    this

  update: (@model) ->
    mode   = if @model? then @model.get 'mode'
    mode or= Script.defaultMode

    @$("option[value='#{mode}']").prop 'selected', yes

    do @updateMode

  updateMode: ->
    mode = @$el.val()

    @options.ace.getSession().setMode "ace/mode/#{mode}"

    @model.save { mode } if @model?

# View containing options that allow the user to configure the Ace editor.
EditorSettings = Backbone.View.extend

  el: '#editor_settings'

  template: _.template '<option value="<%- value %>"><%= html %></option>'

  # TODO: Would `'change': 'update'` suffice?
  events:
    'change #editor_indent_size': 'update'
    'change #editor_line_wrap':   'update'
    'change #editor_soft_tabs':   'update'
    'change #editor_theme':       'update'

  initialize: ->
    $sizes = @$ '#editor_indent_size optgroup'
    _.each options.config.editor.indentSizes, (size) =>
      $sizes.append @template
        html:  size
        value: size

    $themes = @$ '#editor_theme optgroup'
    _.each options.config.editor.themes, (theme) =>
      $themes.append @template
        html:  i18n.get "editor_theme_#{theme}"
        value: theme

    @listenTo @model, """
      change:indentSize
      change:lineWrap
      change:softTabs
      change:theme
    """, @render

  render: ->
    indentSize = @model.get 'indentSize'
    lineWrap   = @model.get 'lineWrap'
    softTabs   = @model.get 'softTabs'
    theme      = @model.get 'theme'

    @$("""
      #editor_indent_size option[value='#{indentSize}'],
      #editor_line_wrap   option[value='#{lineWrap}'],
      #editor_soft_tabs   option[value='#{softTabs}'],
      #editor_theme       option[value='#{theme}']
    """).prop 'selected', yes

    this

  update: ->
    $indentSize = @$ '#editor_indent_size'
    $lineWrap   = @$ '#editor_line_wrap'
    $softTabs   = @$ '#editor_soft_tabs'
    $theme      = @$ '#editor_theme'

    @model.save
      indentSize: parseInt $indentSize.val(), 0
      lineWrap:   $lineWrap.val() is 'true'
      softTabs:   $softTabs.val() is 'true'
      theme:      $theme.val()

# Contains the Ace editor that allows the user to modify a script's code.
EditorView = Backbone.View.extend

  el: '#editor'

  initialize: ->
    @ace = ace.edit 'editor'
    @ace.setShowPrintMargin no
    @ace.getSession().on 'change', =>
      @model.trigger 'modified', @hasUnsavedChanges(), @ace.getValue() if @model?

    @settings = new EditorSettings { model: @options.settings }
    @controls = new EditorControls { @ace }
    @modes    = new EditorModes    { @ace }

    @listenTo @options.settings, """
      change:indentSize
      change:lineWrap
      change:softTabs
      change:theme
    """, @updateSettings

    do @updateSettings

  hasUnsavedChanges: ->
    @model? and @model.get('code') isnt @ace.getValue()

  render: ->
    @settings.render()
    @controls.render()
    @modes.render()

    this

  update: (@model) ->
    @ace.setReadOnly not @model?
    @ace.setValue @model?.get('code') or ''
    @ace.gotoLine 0

    @controls.update @model
    @modes.update @model

  updateSettings: ->
    { settings } = @options

    @ace.getSession().setUseWrapMode settings.get 'lineWrap'
    @ace.getSession().setUseSoftTabs settings.get 'softTabs'
    @ace.getSession().setTabSize     settings.get 'indentSize'
    @ace.setTheme "ace/theme/#{settings.get 'theme'}"

# Settings
# --------

# Allows the user to modify the general settings of the extension.
GeneralSettingsView = Backbone.View.extend

  el: '#general_tab'

  events:
    'change #analytics': 'update'

  initialize: ->
    @listenTo @model, 'change:analytics', @render
    @listenTo @model, 'change:analytics', @updateAnalytics

    do @updateAnalytics

  render: ->
    @$('#analytics').prop 'checked', @model.get 'analytics'

    this

  update: ->
    $analytics = @$ '#analytics'

    @model.save { analytics: $analytics.is ':checked' }

  updateAnalytics: ->
    if @model.get 'analytics'
      analytics.add options.config.analytics
    else
      analytics.remove()

# Parent view for all configurable settings.
SettingsView = Backbone.View.extend

  el: 'body'

  initialize: ->
    @general = new GeneralSettingsView { @model }

  render: ->
    @general.render()

    this

# Scripts
# -------

# View contains buttons used to control/manage the user's scripts.
ScriptControls = Backbone.View.extend

  el: '#scripts_controls'

  template: _.template """
    <form id="<%- id %>" class="form-inline" role="form">
      <div class="form-group">
        <%= html %>
      </div>
    </form>
  """

  events:
    'show.bs.popover .btn':           'closeOtherPrompts'
    'click #delete_menu .btn':        'closeOtherPrompts'
    'click #add_button':              'togglePrompt'
    'shown.bs.popover #add_button':   'promptAdd'
    'click #edit_button':             'togglePrompt'
    'shown.bs.popover #edit_button':  'promptEdit'
    'click #clone_button':            'togglePrompt'
    'shown.bs.popover #clone_button': 'promptClone'
    'click #delete_menu .js-resolve': 'removeScript'

  initialize: ->
    @$('#add_button, #clone_button, #edit_button').popover
      html:      yes
      trigger:   'manual'
      placement: 'bottom'
      container: 'body'
      content:   @template
        id:   'edit_script'
        html: '<input type="text" class="form-control" spellcheck="false" placeholder="yourdomain.com">'

  closeOtherPrompts: (e) ->
    @$('.js-popover-toggle').not(e.currentTarget).popover 'hide'
    $('.popover').remove()

  promptAdd: (e) ->
    @promptDomain e

  promptClone: (e) ->
    return if not @model?

    @promptDomain e, clone: yes

  promptDomain: (e, options = {}) ->
    $button = $ e.currentTarget
    $form   = $ '#edit_script'
    value   = if options.clone or options.edit then @model.get 'host' else ''

    $form.on 'submit', (e) =>
      $group = $form.find '.form-group'
      host   = $form.find(':text').val().replace /\s+/g, ''

      if not host
        $group.addClass 'has-error'
      else
        $group.removeClass 'has-error'

        if options.edit
          @model.save { host }
        else
          base = if options.clone then @model else new Script

          @collection.create {
            host
            code: base.get('code') or ''
            mode: base.get('mode') or Script.defaultMode
          }, success: (model) ->
            model.activate()

      $button.popover 'hide'

      false

    $form.find(':text').focus().val value

  promptEdit: (e) ->
    return if not @model?

    @promptDomain e, edit: yes

  removeScript: ->
    return if not @model?

    model = @model
    model.deactivate().done ->
      model.destroy()

  togglePrompt: (e) ->
    $button = $ e.currentTarget

    $button.popover 'toggle' unless $button.hasClass 'disabled'

  update: (@model) ->
    $modelButtons = @$ '#clone_button, #delete_menu .btn, #edit_button'

    @$('#add_button').removeClass 'disabled'

    if @model?
      $modelButtons.removeClass 'disabled'
    else
      $modelButtons.addClass('disabled').popover 'hide'

# Menu item which, when selected, makes the underlying script *active*, enabling the user to manage
# it and modify it's code.
ScriptItem = Backbone.View.extend

  tagName: 'li'

  template: _.template '<a><%= host %></a>'

  events:
    'click a': 'activate'

  initialize: ->
    @listenTo @model, 'destroy', @remove
    @listenTo @model, 'modified', @modified
    @listenTo @model, 'change:active change:host', @render

  activate: (e) ->
    if e.ctrlKey
      @model.deactivate()
    else unless @$el.hasClass 'active'
      @model.activate()

  modified: (changed) ->
    if changed
      @$el.addClass 'modified'
    else
      @$el.removeClass 'modified'

  render: ->
    @$el.html @template @model.attributes

    if @model.get 'active'
      @$el.addClass 'active'
    else
      @$el.removeClass 'active'

    this

# A menu of scripts that allows the user to easily manage them.
ScriptsList = Backbone.View.extend

  tagName: 'ul'

  className: 'nav nav-pills nav-stacked'

  addOne: (model) ->
    @$el.append new ScriptItem({ model }).render().$el

  addAll: ->
    @collection.each @addOne, this

  initialize: ->
    @listenTo @collection, 'add', @addOne
    @listenTo @collection, 'reset', @addAll

  render: ->
    do @addAll

    this

# The primary view for managing scripts.
ScriptsView = Backbone.View.extend

  el: '#scripts_tab'

  initialize: ->
    @controls = new ScriptControls { @collection }
    @list     = new ScriptsList { @collection }

  render: ->
    @controls.render()

    @$('#scripts_list').append @list.render().$el

    this

  update: (model) ->
    @controls.update model

# Miscellaneous
# -------------

# Activate tooltip effects, optionally only within a specific context.
activateTooltips = (selector) ->
  base = $ selector or document

  # Reset all previously treated tooltips.
  base.find('[data-original-title]').each ->
    $this = $ this

    $this.tooltip 'destroy'
    $this.attr 'title', $this.attr 'data-original-title'
    $this.removeAttr 'data-original-title'

  # Apply tooltips to all relevant elements.
  base.find('[title]').each ->
    $this = $ this

    $this.tooltip
      container: $this.attr('data-container') or 'body'
      placement: $this.attr('data-placement') or 'top'

# Options page setup
# ------------------

options = window.options = new class Options

  # Create a new instance of `Options`.
  constructor: ->
    @config  = {}
    @version = ''

  # Public functions
  # ----------------

  # Initialize the options page.  
  # This will involve inserting and configuring the UI elements as well as loading the current
  # settings.
  init: ->
    # It's nice knowing what version is running.
    { @version } = chrome.runtime.getManifest()

    # Load the configuration data from the file before storing it locally.
    $.getJSON chrome.extension.getURL('configuration.json'), (@config) =>
      # Add the user feedback feature to the page.
      loadFeedback @config.options.userVoice

      # Begin initialization.
      i18n.traverse()

      # Retrieve all singleton instances as well as the collection for user-created scripts.
      models.fetch (result) =>
        { settings, editorSettings, scripts } = result

        # Create views for the important models and collections.
        @editor   = new EditorView(settings: editorSettings).render()
        @settings = new SettingsView(model: settings).render()
        @scripts  = new ScriptsView(collection: scripts).render()

        # Ensure that views are updated accordingly when scripts are activated and deactivated.
        scripts.on 'activate deactivate', (script) =>
          if script.get 'active' then @update script else do @update

        activeScript = scripts.findWhere { active: yes }
        @update activeScript if activeScript

        # Ensure the current year is displayed throughout, where appropriate.
        $('.js-insert-year').html "#{new Date().getFullYear()}"

        # Bind tab selection event to all tabs.
        initialTabChange = yes
        $('a[data-tabify]').on 'click', ->
          target = $(this).data 'tabify'
          nav    = $ "header.navbar .nav a[data-tabify='#{target}']"
          parent = nav.parent 'li'

          unless parent.hasClass 'active'
            parent.addClass('active').siblings().removeClass 'active'
            $(target).removeClass('hide').siblings('.tab').addClass 'hide'

            id = nav.attr 'id'
            settings.save(tab: id).then ->
              unless initialTabChange
                id = _.capitalize id.match(/(\S*)_nav$/)[1]
                analytics.track 'Tabs', 'Changed', id

              initialTabChange = no
              $(document.body).scrollTop 0

        # Reflect the previously persisted tab initially.
        $("##{settings.get 'tab'}").trigger 'click'

        # Ensure that form submissions don't reload the page.
        $('form:not([target="_blank"])').on 'submit', -> false

        # Ensure that popovers are closed when the Esc key is pressed anywhere.
        $(document).on 'keydown', (e) ->
          $('.js-popover-toggle').popover 'hide' if e.keyCode is 27

        # Support *goto* navigation elements that change the current scroll position when clicked.
        $('[data-goto]').on 'click', ->
          switch $(this).data 'goto'
            when 'top' then $(document.body).scrollTop 0

        # Bind analytical tracking events to key footer buttons and links.
        $('footer a[href*="neocotic.com"]').on 'click', ->
          analytics.track 'Footer', 'Clicked', 'Homepage'

        # Setup and configure the donation button in the footer.
        $('#donation input[name="hosted_button_id"]').val @config.options.payPal
        $('.js-donate').on 'click', ->
          $(this).tooltip 'hide'

          $('#donation').submit()

          analytics.track 'Footer', 'Clicked', 'Donate'

        do activateTooltips

  # Update the primary views with the active `script` provided.
  update: (script) ->
    @editor.update script
    @scripts.update script

# Initialize `options` when the DOM is ready.
$ -> options.init()

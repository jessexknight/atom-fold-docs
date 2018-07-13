{CompositeDisposable} = require 'atom'
# exports
module.exports =
  configDefaults:
    cozy: true
    start: '"""'
    end: '"""'
  config:
    start:
      title: 'Start of the docstring'
      description: 'RegExp identifying the start of a docstring'
      type: 'string'
      default: '"""'
      order: 1
    end:
      title: 'End of the docstring'
      description: 'RegExp identifying the end of a docstring'
      type: 'string'
      default: '"""'
      order: 2
    cozy:
      title: ''
      type: 'boolean'
      default: true
      description: 'No gaps between filtered lines (default is one line)'
      order: 3
  subscriptions: null

  # activation stuff with state
  activate: ->
    @toggle = false
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-text-editor',
      'fold-docs:toggle': => @main(@toggle)

  # standard deactivation stuff
  deactivate: ->
    @subscriptions.dispose()

  # main function
  main: (@toggle) ->

    # get the editor
    editor = atom.workspace.getActiveTextEditor()

    # if we are not yet toggled
    if !@toggle

      # toggle on
      @toggle = true

      # define the RegExp
      anymatch = '(.|\n)*?'
      re = new RegExp(atom.config.get('fold-docs.start') +
                      anymatch +
                      atom.config.get('fold-docs.end'),
                      'gm')

      # scan the text for the RegExp
      docs = []
      editor.scan re, (m) ->
        docs.push.apply(docs,[m.range.start.row..m.range.end.row])

      # create binary vector of lines to fold
      tofold  = [0..editor.getLineCount()].map (x) => (docs.indexOf(x) != -1)

      # create fold blocks [[start,stop],[start,stop],...]
      folding = false
      blocks  = []
      for foldline,row in tofold
        if foldline
          if !folding                             # start new fold block
            start = row
            folding = true
          else if row == editor.getLineCount()-1  # end this fold block [eof]
            blocks.push([[start,0],[row-1,999]])
        else
          if folding                              # end this fold block [new match]
            blocks.push([[start,0],[row-1,999]])
            folding = false

      # apply folding
      for block in blocks
        if atom.config.get('fold-docs.cozy') && block[0][0]
          block[0] = [block[0][0]-1,999]
        editor.foldBufferRange(block)

    # we are already toggled
    else

      # toggle off
      @toggle = false

      # unfold everything
      editor.unfoldAll()

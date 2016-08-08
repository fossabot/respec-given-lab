expect = require 'expect.js'
Lab = require('lab')
lab = exports.lab = Lab.script()
gwt = require('respec-given-lab')(lab)
{describe, context} = gwt
{Given, When, Then, And, Cleanup, ThenFail} = gwt

describe "Cleanup(fn)", ->

  describe "cleanup is run", ->

    context 'when Then pass', ->
      info = []
      Then -> 'pass'
      And -> info.push 'A'
      Cleanup -> info.push "C"

      describe "verify", ->
        Then -> expect(["A", "C"]).to.eql info

    context 'when Then fail', ->
      info = []
      ThenFail -> false
      And -> info.push 'A'
      Cleanup -> info.push "C"

      describe "verify", ->
        Then -> expect(["C"]).to.eql info

    context 'when other Cleanup fail', ->
      info = []
      ThenFail -> false
      Cleanup -> throw new Error 'oops!'
      Cleanup -> info.push "C"

      describe "verify", ->
        Then -> expect(["C"]).to.eql info

  describe "with nested cleanups", ->
    info = []
    Cleanup -> info.push "C-OUTER"

    context "inner", ->
      Then -> info.push "T-INNER"
      And -> info.push "A-INNER"
      Cleanup -> info.push "C-INNER"

      context "verify", ->
        Then -> expect(info).to.eql ["T-INNER", "A-INNER", "C-OUTER", "C-INNER"]

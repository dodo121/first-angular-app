controllers = angular.module('controllers')

controllers.filter 'byLetter', ->
  (letter, recipes) ->
    out = {}
    out = (recipe for recipe in recipes when recipe.name.charAt(0).toUpperCase() is letter)
    out

controllers.controller("RecipesController",
[
  '$scope',
  '$routeParams',
  '$location',
  '$resource',
  '$filter'
  ($scope,$routeParams,$location,$resource,$filter)->
    $scope.search = (keywords)-> $location.path("/").search('keywords', keywords)
    Recipe = $resource('/recipes/:recipeId', { recipeId: "@id", format: 'json' })

    allRecipes = Recipe.query()

    setSearchTitle = ->
      $scope.listTitle = "Search results"

    setDefaultTitle = ->
      $scope.listTitle = "List of all recipes"

    if $routeParams.keywords
      Recipe.query(keywords: $routeParams.keywords, (results)-> $scope.recipes = results)
      setSearchTitle()
    else
      $scope.recipes = allRecipes
      setDefaultTitle()

    allRecipes.$promise.then( ->
      possibleLetters = (recipe.name.charAt(0) for recipe in allRecipes)
      $scope.alphabetLetters = possibleLetters.sort()
    )

    $scope.findByLetter = (letter) ->
      $scope.recipes = ($filter('byLetter')(letter, allRecipes))
      setSearchTitle()

    $scope.resetSearch = ->
      $scope.recipes = allRecipes
      setDefaultTitle()

    $scope.view = (recipeId)-> $location.path("/recipes/#{recipeId}")

    $scope.newRecipe = -> $location.path("/recipes/new")
    $scope.edit = (recipeId)-> $location.path("/recipes/#{recipeId}/edit")
])

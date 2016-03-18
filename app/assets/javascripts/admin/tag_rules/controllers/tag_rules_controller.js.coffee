angular.module("admin.tagRules").controller "TagRulesCtrl", ($scope, $http, enterprise) ->
  $scope.tagGroups = enterprise.tag_groups

  $scope.visibilityOptions = [ { id: "visible", name: "VISIBLE" }, { id: "hidden", name: "NOT VISIBLE" } ]

  updateRuleCounts = ->
    index = 0
    for tagGroup in $scope.tagGroups
      tagGroup.startIndex = index
      index = index + tagGroup.rules.length

  updateRuleCounts()

  $scope.updateTagsRulesFor = (tagGroup) ->
    for tagRule in tagGroup.rules
      tagRule.preferred_customer_tags = (tag.text for tag in tagGroup.tags).join(",")

  $scope.addNewRuleTo = (tagGroup, ruleType) ->
    newRule =
        id: null
        preferred_customer_tags: (tag.text for tag in tagGroup.tags).join(",")
        type: "TagRule::#{ruleType}"
    switch ruleType
      when "DiscountOrder"
        newRule.calculator = { preferred_flat_percent: 0 }
      when "FilterShippingMethods"
        newRule.peferred_shipping_method_tags = []
        newRule.preferred_matched_shipping_methods_visibility = "visible"
    tagGroup.rules.push(newRule)
    updateRuleCounts()

  $scope.addNewTag = ->
    $scope.tagGroups.push { tags: [], rules: [] }

  $scope.deleteTagRule = (tagGroup, tagRule) ->
    index = tagGroup.rules.indexOf(tagRule)
    return unless index >= 0
    if tagRule.id is null
      tagGroup.rules.splice(index, 1)
      updateRuleCounts()
    else
      if confirm("Are you sure?")
        $http
          method: "DELETE"
          url: "/admin/enterprises/#{enterprise.id}/tag_rules/#{tagRule.id}.json"
        .success ->
          tagGroup.rules.splice(index, 1)
          updateRuleCounts()

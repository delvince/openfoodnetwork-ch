angular.module("admin.variantOverrides").directive "ofnTrackVariantOverride", (DirtyVariantOverrides) ->
  require: "ngModel"
  link: (scope, element, attrs, ngModel) ->
    ngModel.$parsers.push (viewValue) ->
      if ngModel.$dirty
        variantOverride = scope.variantOverrides[scope.hub_id][scope.variant.id]
        scope.inherit = false
        DirtyVariantOverrides.add variantOverride
        scope.displayDirty()
      viewValue

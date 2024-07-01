
## How to release a version

- create release branch `release/vA.B.C`
- run `bundle exec fastlane prepare_release`, this will update the version number in the podspec based on the release branch.
- merge the automatically created PR
- manually trigger the publish_release workflow on master branch

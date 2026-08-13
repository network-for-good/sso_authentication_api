# NFG-4198 — Fix CircleCI deprecated image warning: sso_authentication_api

## Commit Message

```
NFG-4198: Fix CircleCI deprecated image warning + Ruby 3.4.2 upgrade

CI was running on deprecated circleci/* image (warning since 2022).
Also fixes a JWT empty-key spec failure surfaced by the Ruby upgrade
(token_decoder master now requires jwt >= 2.7).

Root causes fixed:

1. Deprecated Docker image (circleci/ruby:2.7.5-node-browsers) stopped
   receiving security updates. Replaced with cimg/ruby:3.4.2 (standard
   image — tests use sqlite3, not a browser stack).

2. Old config version: 2 upgraded to 2.1; circleci/ruby@0.1.2 orb
   upgraded to circleci/ruby@2.6.0 with ruby/install-deps and
   Gemfile.lock-based cache key.

3. Removed unused circleci/postgres and circleci/redis services — the
   gem's test database uses sqlite3 (spec/dummy/config/database.yml);
   neither service is exercised by the specs.

4. Ruby 3.1.4 is EOL (March 2025). Upgraded to 3.4.2 to match DM, FP,
   and Auctions CI.

5. gemspec had no required_ruby_version; added >= 3.1 to exclude EOL
   Rubies (3.0 reached end-of-life March 2024) while the 3.4.2
   dev/CI baseline remains the target.

6. jwt >= 2.7 (enforced by token_decoder master) rejects empty HMAC
   keys. The spec encoded qa_token with empty string key and token_decoder
   HMAC fallback also used empty string when hmac_secret is nil. Fixed
   by using a named test secret in the spec and setting
   TokenDecoder::Decoder.hmac_secret to match in before/after blocks.

7. Gemfile.lock removed from .gitignore — committed to repo for
   reproducible CI caching (consistent with other nfg-gems).

- .circleci/config.yml: 2.1, circleci/ruby@2.6.0, cimg/ruby:3.4.2,
  ruby/install-deps, removed postgres/redis services, explicit workflows block
- .ruby-version: 3.1.4 -> 3.4.2
- .gitignore: removed Gemfile.lock exclusion
- sso_authentication_api.gemspec: added required_ruby_version >= 3.0
- Gemfile.lock: committed for first time (rails 7.2.3.2, bundler 4.0.4)
- spec/.../authentications_controller_spec.rb: use named JWT secret +
  set TokenDecoder::Decoder.hmac_secret in before/after

14 examples, 0 failures on Ruby 3.4.2
```

## Problem

CI on `sso_authentication_api` showed a persistent deprecation warning:
> "You're using a deprecated Docker convenience image. Upgrade to a next-gen
> Docker convenience image."

There were multiple layered issues:

1. **Deprecated Docker image:** `circleci/ruby:2.7.5-node-browsers` is a legacy
   image that stopped receiving security updates.

2. **Old CircleCI config format:** `version: 2` (not `2.1`) without an orb or
   explicit workflows block. Used `circleci/ruby@0.1.2` with manual bundler
   install, restore_cache, and save_cache steps.

3. **Unused CI services:** `circleci/postgres:11.5` and `circleci/redis:4`
   (both deprecated images) were defined as CI services but never used —
   the gem's test database is sqlite3 (`spec/dummy/config/database.yml`) and
   no spec touches Redis.

4. **Ruby 3.1.4 is EOL:** End-of-life March 2025. Upgraded to 3.4.2 to
   match DM, FP, and Auctions CI.

5. **Missing `required_ruby_version`:** gemspec had no minimum Ruby constraint,
   so consumers could attempt to install on any Ruby version.

6. **JWT empty HMAC key rejected by jwt >= 2.7:** The spec created test tokens
   with `JWT.encode({ env: 'test' }, '', 'HS256')` (empty key). jwt >= 2.7
   enforces non-empty HMAC keys and raises `JWT::DecodeError: HMAC key cannot
   be empty` at encode time. The `token_decoder` gem (pulled from master)
   now requires `jwt >= 2.7`, so this was already failing after that update.
   The same issue existed in `TokenDecoder::Decoder`'s HMAC fallback, which
   decodes with `hmac_secret || ''` — also empty when `hmac_secret` is nil.

7. **Gemfile.lock in .gitignore:** The lockfile was excluded from git (old
   gem-repo convention), but `ruby/install-deps` needs it for content-based
   cache keys. Removed the exclusion and committed the lockfile, consistent
   with all other nfg-gems updated in this epic.

## What Changed

### `.circleci/config.yml`

- `version: 2` → `2.1`
- Orb added: `circleci/ruby@2.6.0`
- Removed deprecated image: `circleci/ruby:2.7.5-node-browsers` → `cimg/ruby:3.4.2`
  (standard image — no browser deps in this gem's specs)
- **Removed** `circleci/postgres:11.5` and `circleci/redis:4` services — unused;
  test DB is sqlite3, no Redis calls in specs
- Replaced manual `gem install bundler`, `bundle install --path vendor/bundle`,
  `restore_cache`, `save_cache` with `ruby/install-deps` using Gemfile.lock cache key
- Added `working_directory: ~/repo`
- Kept `bundle exec rake db:drop db:create db:migrate` (sqlite3 dummy app setup)
- Added explicit `workflows` block (best practice for version 2.1)

### `.ruby-version`

- `3.1.4` → `3.4.2` — aligns local development with CI; matches DM, FP, and Auctions

### `.gitignore`

- Removed `Gemfile.lock` exclusion — committed for reproducible CI dependency caching;
  consistent with token_decoder, nfg_auctions_api_client, nfg_pendo, guide_star_api

### `sso_authentication_api.gemspec`

- Changed `s.required_ruby_version` from `>= 3.0` to `>= 3.1` — Ruby 3.0 is
  EOL (March 2024); constraint now excludes unsupported runtimes

### `Gemfile.lock`

- Committed for the first time (was gitignored since 2015)
- rails 7.2.3.2, rspec-rails 6.1.5, sqlite3 2.9.6, `BUNDLED WITH 4.0.4`

### `spec/controllers/.../authentications_controller_spec.rb`

- Added `let(:jwt_test_secret) { 'sso_api_test_secret' }`
- `before` block sets `TokenDecoder::Decoder.hmac_secret = jwt_test_secret`
  so the decoder's HMAC fallback uses the same non-empty key
- `after` block resets `TokenDecoder::Decoder.hmac_secret = nil` to prevent
  test state leaking between examples
- `JWT.encode({ env: 'test' }, '', 'HS256')` → `JWT.encode({ env: 'test' }, jwt_test_secret, 'HS256')`

## Consumer App Impact

**FP (Givecorps-site):** uses `sso_authentication_api >= 7.2.0.uat.1` — not
affected by these changes (no gem API changes).

**DM:** uses `sso_authentication_api` from git branch `rails_7.2` — not affected.

The JWT spec fix is test-only; no production code changed. The `required_ruby_version`
addition documents an existing constraint (FP and DM both run Ruby 3.x).

## Test Plan

```bash
bundle exec rake db:drop db:create db:migrate   # set up sqlite3 dummy DB
bundle exec rspec                               # 14 examples, 0 failures — verified locally on Ruby 3.4.2
```

## Related

- Jira: [NFG-4198](https://bonterra.atlassian.net/browse/NFG-4198) | Parent story: [NFG-4062](https://bonterra.atlassian.net/browse/NFG-4062) | Epic: [NFG-4070](https://bonterra.atlassian.net/browse/NFG-4070)

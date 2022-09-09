# Copyright 2022 Bedford Freeman & Worth Pub Grp LLC DBA Macmillan Learning.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

## TODO: Also do this stuff: https://www.tidymodels.org/learn/develop/models/
## The rough ideas is that we'll have a single function along the lines of bert
## (equivalent to, for example, parsnip::boost_tree), with a "mode" that
## switches between classification and regression. That way this single
## parsnip function is the "hub" for people to think about how their problem
## might work. I think. tabnet does something like this.

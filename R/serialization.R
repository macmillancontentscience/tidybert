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

.serialize_luz_model <- function(luz_model) {
  # We serialize just the state_dict. That will allow us to "repair" a loaded
  # model in place.

  con <- rawConnection(raw(), open = "wr")
  torch::torch_save(luz_model$model$state_dict(), con)
  on.exit({close(con)}, add = TRUE)
  luz_model$serialized_state_dict <- rawConnectionValue(con)
  return(luz_model)
}

.check_luz_model_serialization <- function(luz_model) {
  if (.is_null_external_pointer(luz_model$model$.check$ptr)) {
    .unserialize_luz_model(luz_model)
  }
  return(invisible(luz_model))
}

.is_null_external_pointer <- function(pointer) {
  a <- attributes(pointer)
  attributes(pointer) <- NULL
  out <- identical(pointer, methods::new("externalptr"))
  attributes(pointer) <- a
  return(out)
}

.unserialize_luz_model <- function(luz_model) {
  # Do this in place.
  con <- rawConnection(luz_model$serialized_state_dict)
  on.exit({close(con)}, add = TRUE)
  luz_model$model$load_state_dict(
    torch::torch_load(con)
  )
  return(invisible(luz_model))
}

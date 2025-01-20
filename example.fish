set --local dirs app/ lib/ config/ db/

set --local models (
  rg \
    --no-filename \
    --no-heading \
    --no-line-number \
    --replace="\$1" \
    "class (\w+) < ApplicationRecord" \
    $dirs
)

for model in $models
  set --local nums (rg --count-matches --no-filename "\b$model\b" $dirs)
  set --local expression (string join -- " + " $nums)
  set --local sum (math $expression)

  echo "$model is referenced $sum times"
end

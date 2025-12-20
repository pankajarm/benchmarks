# Running 10 SWE-bench Verified Tasks with OpenAI GPT Model

This guide explains how to run 10 selected tasks from the SWE-bench Verified dataset using an OpenAI GPT model.

## Prerequisites

1. **OpenAI API Key**: You need a valid OpenAI API key
2. **Docker**: Required for local evaluation (or access to remote workspace)
3. **Environment Setup**: Run `make build` to set up the environment

## Setup Instructions

### 1. Configure Your OpenAI API Key

Edit the LLM configuration file `.llm_config/openai-gpt4.json` and replace `YOUR_OPENAI_API_KEY_HERE` with your actual OpenAI API key:

```json
{
  "model": "openai/gpt-4",
  "api_key": "sk-your-actual-api-key-here"
}
```

**Available OpenAI Models:**
- `openai/gpt-4` - GPT-4 (recommended for best results)
- `openai/gpt-4-turbo` - GPT-4 Turbo (faster, more cost-effective)
- `openai/gpt-4o` - GPT-4 Optimized
- `openai/gpt-3.5-turbo` - GPT-3.5 Turbo (faster, lower cost)

**Note:** If you want to use a different model (e.g., GPT-4 Turbo), change the `model` field accordingly.

### 2. Validate Your Configuration

Validate your LLM configuration to ensure it's correct:

```bash
uv run validate-cfg .llm_config/openai-gpt4.json
```

### 3. Review Selected Instances

The file `swebench_10_instances.txt` contains 10 instance IDs from SWE-bench Verified:

```
django__django-11333
django__django-12155
astropy__astropy-7746
matplotlib__matplotlib-23563
pylint-dev__pylint-5859
scikit-learn__scikit-learn-13142
sympy__sympy-14308
pytest-dev__pytest-5227
requests__requests-2148
flask__flask-4992
```

You can modify this file to select different instances if desired.

## Running the Evaluation

### Option 1: Docker Workspace (Local Evaluation)

**Step 1: Build Docker Images**

Before running inference, build Docker images for the selected instances:

```bash
# Note: Set SKIP_BUILD=0 to build images during runtime
export SKIP_BUILD=0

# Or pre-build all images (recommended)
uv run python -m benchmarks.swebench.build_images \
  --dataset princeton-nlp/SWE-bench_Verified \
  --split test \
  --image ghcr.io/openhands/eval-agent-server \
  --target source-minimal
```

**Step 2: Run Inference**

Run the evaluation on the 10 selected instances:

```bash
uv run swebench-infer .llm_config/openai-gpt4.json \
    --select swebench_10_instances.txt \
    --dataset princeton-nlp/SWE-bench_Verified \
    --split test \
    --max-iterations 100 \
    --workspace docker \
    --num-workers 1 \
    --output-dir ./eval_outputs
```

**Command Options Explained:**
- `--select swebench_10_instances.txt`: Run only the 10 instances listed in this file
- `--max-iterations 100`: Maximum number of agent iterations per task
- `--workspace docker`: Use local Docker containers
- `--num-workers 1`: Run 1 instance at a time (increase for parallel execution)
- `--output-dir`: Directory to save evaluation results

### Option 2: Remote Workspace (Scalable Cloud Evaluation)

**Prerequisites:**
- Pre-built images pushed to a container registry
- `RUNTIME_API_KEY` environment variable set

**Step 1: Set Up Environment Variables**

```bash
export RUNTIME_API_KEY="your-runtime-api-key"
export RUNTIME_API_URL="https://runtime.eval.all-hands.dev"  # Optional
```

**Step 2: Run Inference**

```bash
uv run swebench-infer .llm_config/openai-gpt4.json \
    --select swebench_10_instances.txt \
    --dataset princeton-nlp/SWE-bench_Verified \
    --split test \
    --workspace remote \
    --num-workers 10 \
    --max-iterations 100 \
    --output-dir ./eval_outputs
```

**Note:** With remote workspace, you can run all 10 instances in parallel by setting `--num-workers 10`.

## Monitoring Progress

The evaluation will:
1. Load the 10 selected instances from SWE-bench Verified
2. For each instance:
   - Set up the workspace environment
   - Present the problem to the GPT model
   - Let the model interact with the codebase to solve the issue
   - Generate a patch
3. Save results to `./eval_outputs/` directory

**Expected Runtime:**
- Per instance: 10-30 minutes (depending on task complexity and model speed)
- Total for 10 instances (sequential): 2-5 hours
- Total for 10 instances (parallel with 10 workers): 20-40 minutes

## Evaluating Results

After inference completes, evaluate the generated patches:

```bash
uv run swebench-eval ./eval_outputs/output.jsonl \
  --dataset princeton-nlp/SWE-bench_Verified \
  --output-file results.swebench.jsonl
```

This will:
1. Convert OpenHands output to SWE-Bench format
2. Run the official SWE-Bench evaluation
3. Report pass/fail results for each instance

## Cost Estimation

**Approximate costs per instance** (based on GPT-4 pricing):
- Input tokens: ~50,000 - 200,000 tokens
- Output tokens: ~10,000 - 50,000 tokens
- Cost per instance: $2-$15 (GPT-4) or $0.50-$4 (GPT-4 Turbo)

**Total estimated cost for 10 instances:**
- GPT-4: $20-$150
- GPT-4 Turbo: $5-$40
- GPT-3.5 Turbo: $1-$10

## Troubleshooting

**Error: "LLM config file does not exist"**
- Make sure you've edited `.llm_config/openai-gpt4.json` with your API key

**Error: "Invalid API key"**
- Verify your OpenAI API key is correct
- Check that your API key has sufficient credits

**Error: "Cannot connect to Docker"**
- Ensure Docker is running: `docker ps`
- Check Docker permissions

**Error: "SKIP_BUILD=1 but image not found"**
- Either pre-build images or set `export SKIP_BUILD=0`

## Alternative Models

To use a different OpenAI model, create a new config file or modify the existing one:

```json
{
  "model": "openai/gpt-4-turbo",
  "api_key": "sk-your-api-key-here"
}
```

Then run with the new config:

```bash
uv run swebench-infer .llm_config/your-config.json --select swebench_10_instances.txt ...
```

## Next Steps

- Review the results in `./eval_outputs/`
- Analyze the generated patches
- Run the evaluation to see how many instances passed
- Adjust `max-iterations` or try different models for better results

## References

- [SWE-Bench Official Site](https://www.swebench.com/)
- [OpenAI API Documentation](https://platform.openai.com/docs/api-reference)
- [OpenHands Benchmarks README](./README.md)
- [SWE-Bench Evaluation Guide](./benchmarks/swebench/README.md)

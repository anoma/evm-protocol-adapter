use alloy::transports::http::reqwest::Url;
use alloy_chains::NamedChain;
use std::env;
use thiserror::Error;

pub type RpcResult<T> = Result<T, RpcError>;

#[derive(Error, Debug, Clone)]
pub enum RpcError {
    #[error(
        "No RPC URL configured for chain '{0}'. Set {1} or provide ALCHEMY_API_KEY for supported chains."
    )]
    RpcUrlNotConfigured(String, String),
    #[error("The Alchemy API key is not set in the environment.")]
    ApiKeyNotSet,
    #[error("The url could not be parsed.")]
    UrlParsingError,
}

/// Maps a `NamedChain` to the suffix used for `RPC_URL_<SUFFIX>` env vars.
fn chain_env_var_name(chain: &NamedChain) -> String {
    let s = format!("{chain:?}");
    // Convert CamelCase to UPPER_SNAKE_CASE
    let mut result = String::new();
    for (i, ch) in s.chars().enumerate() {
        if ch.is_uppercase() && i > 0 {
            result.push('_');
        }
        result.push(ch.to_ascii_uppercase());
    }
    result
}

/// Returns the RPC URL for the given chain using a two-tier resolution:
///
/// 1. Check for a chain-specific env var `RPC_URL_<CHAIN>` (e.g., `RPC_URL_MAINNET`)
/// 2. Fall back to constructing an Alchemy URL from `ALCHEMY_API_KEY`
pub fn rpc_url(chain: &NamedChain) -> RpcResult<Url> {
    dotenvy::dotenv().ok();

    let env_var_suffix = chain_env_var_name(chain);
    let env_var_name = format!("RPC_URL_{env_var_suffix}");

    // Tier 1: chain-specific env var override
    if let Ok(url) = env::var(&env_var_name) {
        return url.parse().map_err(|_| RpcError::UrlParsingError);
    }

    // Tier 2: Alchemy fallback for supported chains
    let subdomain = alchemy_subdomain(chain)
        .ok_or_else(|| RpcError::RpcUrlNotConfigured(format!("{chain:?}"), env_var_name.clone()))?;

    let api_key = env::var("ALCHEMY_API_KEY").map_err(|_| RpcError::ApiKeyNotSet)?;

    format!("https://{subdomain}.g.alchemy.com/v2/{api_key}")
        .parse()
        .map_err(|_| RpcError::UrlParsingError)
}

/// Returns the Alchemy subdomain for supported chains.
fn alchemy_subdomain(chain: &NamedChain) -> Option<&'static str> {
    use NamedChain::*;

    match chain {
        Mainnet => Some("eth-mainnet"),
        Sepolia => Some("eth-sepolia"),
        //
        Arbitrum => Some("arb-mainnet"),
        ArbitrumSepolia => Some("arb-sepolia"),
        //
        Optimism => Some("opt-mainnet"),
        OptimismSepolia => Some("opt-sepolia"),
        //
        Base => Some("base-mainnet"),
        BaseSepolia => Some("base-sepolia"),
        //
        BinanceSmartChain => Some("bnb-mainnet"),
        BinanceSmartChainTestnet => Some("bnb-testnet"),
        //
        Polygon => Some("polygon-mainnet"),
        PolygonAmoy => Some("polygon-amoy"),

        _ => None,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn chain_env_var_name_simple() {
        assert_eq!(chain_env_var_name(&NamedChain::Mainnet), "MAINNET");
        assert_eq!(chain_env_var_name(&NamedChain::Sepolia), "SEPOLIA");
    }

    #[test]
    fn chain_env_var_name_compound() {
        assert_eq!(chain_env_var_name(&NamedChain::BaseSepolia), "BASE_SEPOLIA");
        assert_eq!(
            chain_env_var_name(&NamedChain::ArbitrumSepolia),
            "ARBITRUM_SEPOLIA"
        );
        assert_eq!(
            chain_env_var_name(&NamedChain::OptimismSepolia),
            "OPTIMISM_SEPOLIA"
        );
        assert_eq!(chain_env_var_name(&NamedChain::PolygonAmoy), "POLYGON_AMOY");
    }

    #[test]
    fn rpc_url_uses_env_var_override() {
        let chain = NamedChain::Mainnet;
        let env_var = format!("RPC_URL_{}", chain_env_var_name(&chain));
        let test_url = "https://custom-rpc.example.com/v1/key123";

        // SAFETY: This test is single-threaded and we restore the env var after.
        unsafe { env::set_var(&env_var, test_url) };
        let result = rpc_url(&chain).expect("should parse custom URL");
        assert_eq!(result.as_str(), test_url);
        unsafe { env::remove_var(&env_var) };
    }
}

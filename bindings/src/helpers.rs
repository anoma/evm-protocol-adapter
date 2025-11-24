use alloy::transports::http::reqwest::Url;
use alloy_chains::NamedChain;
use std::env;
use thiserror::Error;

pub type AlchemyResult<T> = Result<T, AlchemyError>;

#[derive(Error, Debug, Clone)]
pub enum AlchemyError {
    #[error("The alchemy subdomain was not found for this chain.")]
    SubdomainNotFound,
    #[error("The Alchemy API key is not set in the environment.")]
    ApiKeyEnvVarNotSet,
    #[error("The url could not be parsed.")]
    UrlParsingError,
}

/// Returns the Alchemy RPC URL for the given chain.
pub fn alchemy_url(chain: &NamedChain) -> AlchemyResult<Url> {
    dotenv::dotenv().ok();

    format!(
        "https://{subdomain}.g.alchemy.com/v2/{api_key}",
        subdomain = alchemy_subdomain(chain)?,
        api_key = env::var("API_KEY_ALCHEMY").map_err(|_| AlchemyError::ApiKeyEnvVarNotSet)?
    )
    .parse()
    .map_err(|_| AlchemyError::UrlParsingError)
}

/// Returns the Alchemy subdomain for the given chain.
pub fn alchemy_subdomain(chain: &NamedChain) -> AlchemyResult<&'static str> {
    use NamedChain::*;

    match chain {
        Mainnet => Ok("eth-mainnet"),
        Sepolia => Ok("eth-sepolia"),
        //
        Arbitrum => Ok("arb-mainnet"),
        ArbitrumSepolia => Ok("arb-sepolia"),
        //
        Optimism => Ok("opt-mainnet"),
        OptimismSepolia => Ok("opt-sepolia"),
        //
        Base => Ok("base-mainnet"),
        BaseSepolia => Ok("base-sepolia"),
        //
        Polygon => Ok("polygon-mainnet"),
        PolygonAmoy => Ok("polygon-amoy"),

        _ => Err(AlchemyError::SubdomainNotFound),
    }
}

use alloy::transports::http::reqwest::Url;
use alloy_chains::NamedChain;
use std::env;
use thiserror::Error;

pub type AlchemyResult<T> = Result<T, AlchemyError>;

#[derive(Error, Debug, Clone)]
pub enum AlchemyError {
    #[error("The alchemy subdomain was not found for this chain.")]
    SubdomainNotFound,
    #[error("Thrown when the API key is not set in the environment.")]
    ApiKeyEnvVarNotSet,
    #[error("Thrown when the url_string could not be parsed.")]
    UrlParsingError,
}

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

pub fn alchemy_url(chain: &NamedChain) -> AlchemyResult<Url> {
    dotenv::dotenv().ok();

    let chain_prefix = alchemy_subdomain(chain)?;

    let url_string = format!(
        "https://{}.g.alchemy.com/v2/{}",
        chain_prefix,
        env::var("API_KEY_ALCHEMY").map_err(|_| AlchemyError::ApiKeyEnvVarNotSet)?
    );

    Url::parse(&url_string).map_err(|_| AlchemyError::UrlParsingError)
}

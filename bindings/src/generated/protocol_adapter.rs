///Module containing a contract's types and functions.
/**

```solidity
library Compliance {
    struct ConsumedRefs { bytes32 nullifier; bytes32 logicRef; bytes32 commitmentTreeRoot; }
    struct CreatedRefs { bytes32 commitment; bytes32 logicRef; }
    struct Instance { ConsumedRefs consumed; CreatedRefs created; bytes32 unitDeltaX; bytes32 unitDeltaY; }
    struct VerifierInput { bytes proof; Instance instance; }
}
```*/
#[allow(
    non_camel_case_types,
    non_snake_case,
    clippy::pub_underscore_fields,
    clippy::style,
    clippy::empty_structs_with_brackets
)]
pub mod Compliance {
    use super::*;
    use alloy::sol_types as alloy_sol_types;
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**```solidity
struct ConsumedRefs { bytes32 nullifier; bytes32 logicRef; bytes32 commitmentTreeRoot; }
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct ConsumedRefs {
        #[allow(missing_docs)]
        pub nullifier: alloy::sol_types::private::FixedBytes<32>,
        #[allow(missing_docs)]
        pub logicRef: alloy::sol_types::private::FixedBytes<32>,
        #[allow(missing_docs)]
        pub commitmentTreeRoot: alloy::sol_types::private::FixedBytes<32>,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (
            alloy::sol_types::sol_data::FixedBytes<32>,
            alloy::sol_types::sol_data::FixedBytes<32>,
            alloy::sol_types::sol_data::FixedBytes<32>,
        );
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (
            alloy::sol_types::private::FixedBytes<32>,
            alloy::sol_types::private::FixedBytes<32>,
            alloy::sol_types::private::FixedBytes<32>,
        );
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<ConsumedRefs> for UnderlyingRustTuple<'_> {
            fn from(value: ConsumedRefs) -> Self {
                (value.nullifier, value.logicRef, value.commitmentTreeRoot)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for ConsumedRefs {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self {
                    nullifier: tuple.0,
                    logicRef: tuple.1,
                    commitmentTreeRoot: tuple.2,
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolValue for ConsumedRefs {
            type SolType = Self;
        }
        #[automatically_derived]
        impl alloy_sol_types::private::SolTypeValue<Self> for ConsumedRefs {
            #[inline]
            fn stv_to_tokens(&self) -> <Self as alloy_sol_types::SolType>::Token<'_> {
                (
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.nullifier),
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.logicRef),
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.commitmentTreeRoot),
                )
            }
            #[inline]
            fn stv_abi_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encoded_size(&tuple)
            }
            #[inline]
            fn stv_eip712_data_word(&self) -> alloy_sol_types::Word {
                <Self as alloy_sol_types::SolStruct>::eip712_hash_struct(self)
            }
            #[inline]
            fn stv_abi_encode_packed_to(
                &self,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encode_packed_to(&tuple, out)
            }
            #[inline]
            fn stv_abi_packed_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_packed_encoded_size(&tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolType for ConsumedRefs {
            type RustType = Self;
            type Token<'a> = <UnderlyingSolTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SOL_NAME: &'static str = <Self as alloy_sol_types::SolStruct>::NAME;
            const ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::ENCODED_SIZE;
            const PACKED_ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE;
            #[inline]
            fn valid_token(token: &Self::Token<'_>) -> bool {
                <UnderlyingSolTuple<'_> as alloy_sol_types::SolType>::valid_token(token)
            }
            #[inline]
            fn detokenize(token: Self::Token<'_>) -> Self::RustType {
                let tuple = <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::detokenize(token);
                <Self as ::core::convert::From<UnderlyingRustTuple<'_>>>::from(tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolStruct for ConsumedRefs {
            const NAME: &'static str = "ConsumedRefs";
            #[inline]
            fn eip712_root_type() -> alloy_sol_types::private::Cow<'static, str> {
                alloy_sol_types::private::Cow::Borrowed(
                    "ConsumedRefs(bytes32 nullifier,bytes32 logicRef,bytes32 commitmentTreeRoot)",
                )
            }
            #[inline]
            fn eip712_components() -> alloy_sol_types::private::Vec<
                alloy_sol_types::private::Cow<'static, str>,
            > {
                alloy_sol_types::private::Vec::new()
            }
            #[inline]
            fn eip712_encode_type() -> alloy_sol_types::private::Cow<'static, str> {
                <Self as alloy_sol_types::SolStruct>::eip712_root_type()
            }
            #[inline]
            fn eip712_encode_data(&self) -> alloy_sol_types::private::Vec<u8> {
                [
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::eip712_data_word(&self.nullifier)
                        .0,
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::eip712_data_word(&self.logicRef)
                        .0,
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::eip712_data_word(
                            &self.commitmentTreeRoot,
                        )
                        .0,
                ]
                    .concat()
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::EventTopic for ConsumedRefs {
            #[inline]
            fn topic_preimage_length(rust: &Self::RustType) -> usize {
                0usize
                    + <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.nullifier,
                    )
                    + <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.logicRef,
                    )
                    + <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.commitmentTreeRoot,
                    )
            }
            #[inline]
            fn encode_topic_preimage(
                rust: &Self::RustType,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                out.reserve(
                    <Self as alloy_sol_types::EventTopic>::topic_preimage_length(rust),
                );
                <alloy::sol_types::sol_data::FixedBytes<
                    32,
                > as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.nullifier,
                    out,
                );
                <alloy::sol_types::sol_data::FixedBytes<
                    32,
                > as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.logicRef,
                    out,
                );
                <alloy::sol_types::sol_data::FixedBytes<
                    32,
                > as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.commitmentTreeRoot,
                    out,
                );
            }
            #[inline]
            fn encode_topic(
                rust: &Self::RustType,
            ) -> alloy_sol_types::abi::token::WordToken {
                let mut out = alloy_sol_types::private::Vec::new();
                <Self as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    rust,
                    &mut out,
                );
                alloy_sol_types::abi::token::WordToken(
                    alloy_sol_types::private::keccak256(out),
                )
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**```solidity
struct CreatedRefs { bytes32 commitment; bytes32 logicRef; }
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct CreatedRefs {
        #[allow(missing_docs)]
        pub commitment: alloy::sol_types::private::FixedBytes<32>,
        #[allow(missing_docs)]
        pub logicRef: alloy::sol_types::private::FixedBytes<32>,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (
            alloy::sol_types::sol_data::FixedBytes<32>,
            alloy::sol_types::sol_data::FixedBytes<32>,
        );
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (
            alloy::sol_types::private::FixedBytes<32>,
            alloy::sol_types::private::FixedBytes<32>,
        );
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<CreatedRefs> for UnderlyingRustTuple<'_> {
            fn from(value: CreatedRefs) -> Self {
                (value.commitment, value.logicRef)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for CreatedRefs {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self {
                    commitment: tuple.0,
                    logicRef: tuple.1,
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolValue for CreatedRefs {
            type SolType = Self;
        }
        #[automatically_derived]
        impl alloy_sol_types::private::SolTypeValue<Self> for CreatedRefs {
            #[inline]
            fn stv_to_tokens(&self) -> <Self as alloy_sol_types::SolType>::Token<'_> {
                (
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.commitment),
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.logicRef),
                )
            }
            #[inline]
            fn stv_abi_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encoded_size(&tuple)
            }
            #[inline]
            fn stv_eip712_data_word(&self) -> alloy_sol_types::Word {
                <Self as alloy_sol_types::SolStruct>::eip712_hash_struct(self)
            }
            #[inline]
            fn stv_abi_encode_packed_to(
                &self,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encode_packed_to(&tuple, out)
            }
            #[inline]
            fn stv_abi_packed_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_packed_encoded_size(&tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolType for CreatedRefs {
            type RustType = Self;
            type Token<'a> = <UnderlyingSolTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SOL_NAME: &'static str = <Self as alloy_sol_types::SolStruct>::NAME;
            const ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::ENCODED_SIZE;
            const PACKED_ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE;
            #[inline]
            fn valid_token(token: &Self::Token<'_>) -> bool {
                <UnderlyingSolTuple<'_> as alloy_sol_types::SolType>::valid_token(token)
            }
            #[inline]
            fn detokenize(token: Self::Token<'_>) -> Self::RustType {
                let tuple = <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::detokenize(token);
                <Self as ::core::convert::From<UnderlyingRustTuple<'_>>>::from(tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolStruct for CreatedRefs {
            const NAME: &'static str = "CreatedRefs";
            #[inline]
            fn eip712_root_type() -> alloy_sol_types::private::Cow<'static, str> {
                alloy_sol_types::private::Cow::Borrowed(
                    "CreatedRefs(bytes32 commitment,bytes32 logicRef)",
                )
            }
            #[inline]
            fn eip712_components() -> alloy_sol_types::private::Vec<
                alloy_sol_types::private::Cow<'static, str>,
            > {
                alloy_sol_types::private::Vec::new()
            }
            #[inline]
            fn eip712_encode_type() -> alloy_sol_types::private::Cow<'static, str> {
                <Self as alloy_sol_types::SolStruct>::eip712_root_type()
            }
            #[inline]
            fn eip712_encode_data(&self) -> alloy_sol_types::private::Vec<u8> {
                [
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::eip712_data_word(&self.commitment)
                        .0,
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::eip712_data_word(&self.logicRef)
                        .0,
                ]
                    .concat()
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::EventTopic for CreatedRefs {
            #[inline]
            fn topic_preimage_length(rust: &Self::RustType) -> usize {
                0usize
                    + <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.commitment,
                    )
                    + <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.logicRef,
                    )
            }
            #[inline]
            fn encode_topic_preimage(
                rust: &Self::RustType,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                out.reserve(
                    <Self as alloy_sol_types::EventTopic>::topic_preimage_length(rust),
                );
                <alloy::sol_types::sol_data::FixedBytes<
                    32,
                > as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.commitment,
                    out,
                );
                <alloy::sol_types::sol_data::FixedBytes<
                    32,
                > as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.logicRef,
                    out,
                );
            }
            #[inline]
            fn encode_topic(
                rust: &Self::RustType,
            ) -> alloy_sol_types::abi::token::WordToken {
                let mut out = alloy_sol_types::private::Vec::new();
                <Self as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    rust,
                    &mut out,
                );
                alloy_sol_types::abi::token::WordToken(
                    alloy_sol_types::private::keccak256(out),
                )
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**```solidity
struct Instance { ConsumedRefs consumed; CreatedRefs created; bytes32 unitDeltaX; bytes32 unitDeltaY; }
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct Instance {
        #[allow(missing_docs)]
        pub consumed: <ConsumedRefs as alloy::sol_types::SolType>::RustType,
        #[allow(missing_docs)]
        pub created: <CreatedRefs as alloy::sol_types::SolType>::RustType,
        #[allow(missing_docs)]
        pub unitDeltaX: alloy::sol_types::private::FixedBytes<32>,
        #[allow(missing_docs)]
        pub unitDeltaY: alloy::sol_types::private::FixedBytes<32>,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (
            ConsumedRefs,
            CreatedRefs,
            alloy::sol_types::sol_data::FixedBytes<32>,
            alloy::sol_types::sol_data::FixedBytes<32>,
        );
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (
            <ConsumedRefs as alloy::sol_types::SolType>::RustType,
            <CreatedRefs as alloy::sol_types::SolType>::RustType,
            alloy::sol_types::private::FixedBytes<32>,
            alloy::sol_types::private::FixedBytes<32>,
        );
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<Instance> for UnderlyingRustTuple<'_> {
            fn from(value: Instance) -> Self {
                (value.consumed, value.created, value.unitDeltaX, value.unitDeltaY)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for Instance {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self {
                    consumed: tuple.0,
                    created: tuple.1,
                    unitDeltaX: tuple.2,
                    unitDeltaY: tuple.3,
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolValue for Instance {
            type SolType = Self;
        }
        #[automatically_derived]
        impl alloy_sol_types::private::SolTypeValue<Self> for Instance {
            #[inline]
            fn stv_to_tokens(&self) -> <Self as alloy_sol_types::SolType>::Token<'_> {
                (
                    <ConsumedRefs as alloy_sol_types::SolType>::tokenize(&self.consumed),
                    <CreatedRefs as alloy_sol_types::SolType>::tokenize(&self.created),
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.unitDeltaX),
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.unitDeltaY),
                )
            }
            #[inline]
            fn stv_abi_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encoded_size(&tuple)
            }
            #[inline]
            fn stv_eip712_data_word(&self) -> alloy_sol_types::Word {
                <Self as alloy_sol_types::SolStruct>::eip712_hash_struct(self)
            }
            #[inline]
            fn stv_abi_encode_packed_to(
                &self,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encode_packed_to(&tuple, out)
            }
            #[inline]
            fn stv_abi_packed_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_packed_encoded_size(&tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolType for Instance {
            type RustType = Self;
            type Token<'a> = <UnderlyingSolTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SOL_NAME: &'static str = <Self as alloy_sol_types::SolStruct>::NAME;
            const ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::ENCODED_SIZE;
            const PACKED_ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE;
            #[inline]
            fn valid_token(token: &Self::Token<'_>) -> bool {
                <UnderlyingSolTuple<'_> as alloy_sol_types::SolType>::valid_token(token)
            }
            #[inline]
            fn detokenize(token: Self::Token<'_>) -> Self::RustType {
                let tuple = <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::detokenize(token);
                <Self as ::core::convert::From<UnderlyingRustTuple<'_>>>::from(tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolStruct for Instance {
            const NAME: &'static str = "Instance";
            #[inline]
            fn eip712_root_type() -> alloy_sol_types::private::Cow<'static, str> {
                alloy_sol_types::private::Cow::Borrowed(
                    "Instance(ConsumedRefs consumed,CreatedRefs created,bytes32 unitDeltaX,bytes32 unitDeltaY)",
                )
            }
            #[inline]
            fn eip712_components() -> alloy_sol_types::private::Vec<
                alloy_sol_types::private::Cow<'static, str>,
            > {
                let mut components = alloy_sol_types::private::Vec::with_capacity(2);
                components
                    .push(
                        <ConsumedRefs as alloy_sol_types::SolStruct>::eip712_root_type(),
                    );
                components
                    .extend(
                        <ConsumedRefs as alloy_sol_types::SolStruct>::eip712_components(),
                    );
                components
                    .push(
                        <CreatedRefs as alloy_sol_types::SolStruct>::eip712_root_type(),
                    );
                components
                    .extend(
                        <CreatedRefs as alloy_sol_types::SolStruct>::eip712_components(),
                    );
                components
            }
            #[inline]
            fn eip712_encode_data(&self) -> alloy_sol_types::private::Vec<u8> {
                [
                    <ConsumedRefs as alloy_sol_types::SolType>::eip712_data_word(
                            &self.consumed,
                        )
                        .0,
                    <CreatedRefs as alloy_sol_types::SolType>::eip712_data_word(
                            &self.created,
                        )
                        .0,
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::eip712_data_word(&self.unitDeltaX)
                        .0,
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::eip712_data_word(&self.unitDeltaY)
                        .0,
                ]
                    .concat()
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::EventTopic for Instance {
            #[inline]
            fn topic_preimage_length(rust: &Self::RustType) -> usize {
                0usize
                    + <ConsumedRefs as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.consumed,
                    )
                    + <CreatedRefs as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.created,
                    )
                    + <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.unitDeltaX,
                    )
                    + <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.unitDeltaY,
                    )
            }
            #[inline]
            fn encode_topic_preimage(
                rust: &Self::RustType,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                out.reserve(
                    <Self as alloy_sol_types::EventTopic>::topic_preimage_length(rust),
                );
                <ConsumedRefs as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.consumed,
                    out,
                );
                <CreatedRefs as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.created,
                    out,
                );
                <alloy::sol_types::sol_data::FixedBytes<
                    32,
                > as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.unitDeltaX,
                    out,
                );
                <alloy::sol_types::sol_data::FixedBytes<
                    32,
                > as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.unitDeltaY,
                    out,
                );
            }
            #[inline]
            fn encode_topic(
                rust: &Self::RustType,
            ) -> alloy_sol_types::abi::token::WordToken {
                let mut out = alloy_sol_types::private::Vec::new();
                <Self as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    rust,
                    &mut out,
                );
                alloy_sol_types::abi::token::WordToken(
                    alloy_sol_types::private::keccak256(out),
                )
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**```solidity
struct VerifierInput { bytes proof; Instance instance; }
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct VerifierInput {
        #[allow(missing_docs)]
        pub proof: alloy::sol_types::private::Bytes,
        #[allow(missing_docs)]
        pub instance: <Instance as alloy::sol_types::SolType>::RustType,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::Bytes, Instance);
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (
            alloy::sol_types::private::Bytes,
            <Instance as alloy::sol_types::SolType>::RustType,
        );
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<VerifierInput> for UnderlyingRustTuple<'_> {
            fn from(value: VerifierInput) -> Self {
                (value.proof, value.instance)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for VerifierInput {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self {
                    proof: tuple.0,
                    instance: tuple.1,
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolValue for VerifierInput {
            type SolType = Self;
        }
        #[automatically_derived]
        impl alloy_sol_types::private::SolTypeValue<Self> for VerifierInput {
            #[inline]
            fn stv_to_tokens(&self) -> <Self as alloy_sol_types::SolType>::Token<'_> {
                (
                    <alloy::sol_types::sol_data::Bytes as alloy_sol_types::SolType>::tokenize(
                        &self.proof,
                    ),
                    <Instance as alloy_sol_types::SolType>::tokenize(&self.instance),
                )
            }
            #[inline]
            fn stv_abi_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encoded_size(&tuple)
            }
            #[inline]
            fn stv_eip712_data_word(&self) -> alloy_sol_types::Word {
                <Self as alloy_sol_types::SolStruct>::eip712_hash_struct(self)
            }
            #[inline]
            fn stv_abi_encode_packed_to(
                &self,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encode_packed_to(&tuple, out)
            }
            #[inline]
            fn stv_abi_packed_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_packed_encoded_size(&tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolType for VerifierInput {
            type RustType = Self;
            type Token<'a> = <UnderlyingSolTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SOL_NAME: &'static str = <Self as alloy_sol_types::SolStruct>::NAME;
            const ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::ENCODED_SIZE;
            const PACKED_ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE;
            #[inline]
            fn valid_token(token: &Self::Token<'_>) -> bool {
                <UnderlyingSolTuple<'_> as alloy_sol_types::SolType>::valid_token(token)
            }
            #[inline]
            fn detokenize(token: Self::Token<'_>) -> Self::RustType {
                let tuple = <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::detokenize(token);
                <Self as ::core::convert::From<UnderlyingRustTuple<'_>>>::from(tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolStruct for VerifierInput {
            const NAME: &'static str = "VerifierInput";
            #[inline]
            fn eip712_root_type() -> alloy_sol_types::private::Cow<'static, str> {
                alloy_sol_types::private::Cow::Borrowed(
                    "VerifierInput(bytes proof,Instance instance)",
                )
            }
            #[inline]
            fn eip712_components() -> alloy_sol_types::private::Vec<
                alloy_sol_types::private::Cow<'static, str>,
            > {
                let mut components = alloy_sol_types::private::Vec::with_capacity(1);
                components
                    .push(<Instance as alloy_sol_types::SolStruct>::eip712_root_type());
                components
                    .extend(
                        <Instance as alloy_sol_types::SolStruct>::eip712_components(),
                    );
                components
            }
            #[inline]
            fn eip712_encode_data(&self) -> alloy_sol_types::private::Vec<u8> {
                [
                    <alloy::sol_types::sol_data::Bytes as alloy_sol_types::SolType>::eip712_data_word(
                            &self.proof,
                        )
                        .0,
                    <Instance as alloy_sol_types::SolType>::eip712_data_word(
                            &self.instance,
                        )
                        .0,
                ]
                    .concat()
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::EventTopic for VerifierInput {
            #[inline]
            fn topic_preimage_length(rust: &Self::RustType) -> usize {
                0usize
                    + <alloy::sol_types::sol_data::Bytes as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.proof,
                    )
                    + <Instance as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.instance,
                    )
            }
            #[inline]
            fn encode_topic_preimage(
                rust: &Self::RustType,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                out.reserve(
                    <Self as alloy_sol_types::EventTopic>::topic_preimage_length(rust),
                );
                <alloy::sol_types::sol_data::Bytes as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.proof,
                    out,
                );
                <Instance as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.instance,
                    out,
                );
            }
            #[inline]
            fn encode_topic(
                rust: &Self::RustType,
            ) -> alloy_sol_types::abi::token::WordToken {
                let mut out = alloy_sol_types::private::Vec::new();
                <Self as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    rust,
                    &mut out,
                );
                alloy_sol_types::abi::token::WordToken(
                    alloy_sol_types::private::keccak256(out),
                )
            }
        }
    };
    use alloy::contract as alloy_contract;
    /**Creates a new wrapper around an on-chain [`Compliance`](self) contract instance.

See the [wrapper's documentation](`ComplianceInstance`) for more details.*/
    #[inline]
    pub const fn new<
        P: alloy_contract::private::Provider<N>,
        N: alloy_contract::private::Network,
    >(
        address: alloy_sol_types::private::Address,
        __provider: P,
    ) -> ComplianceInstance<P, N> {
        ComplianceInstance::<P, N>::new(address, __provider)
    }
    /**A [`Compliance`](self) instance.

Contains type-safe methods for interacting with an on-chain instance of the
[`Compliance`](self) contract located at a given `address`, using a given
provider `P`.

If the contract bytecode is available (see the [`sol!`](alloy_sol_types::sol!)
documentation on how to provide it), the `deploy` and `deploy_builder` methods can
be used to deploy a new instance of the contract.

See the [module-level documentation](self) for all the available methods.*/
    #[derive(Clone)]
    pub struct ComplianceInstance<P, N = alloy_contract::private::Ethereum> {
        address: alloy_sol_types::private::Address,
        provider: P,
        _network: ::core::marker::PhantomData<N>,
    }
    #[automatically_derived]
    impl<P, N> ::core::fmt::Debug for ComplianceInstance<P, N> {
        #[inline]
        fn fmt(&self, f: &mut ::core::fmt::Formatter<'_>) -> ::core::fmt::Result {
            f.debug_tuple("ComplianceInstance").field(&self.address).finish()
        }
    }
    /// Instantiation and getters/setters.
    impl<
        P: alloy_contract::private::Provider<N>,
        N: alloy_contract::private::Network,
    > ComplianceInstance<P, N> {
        /**Creates a new wrapper around an on-chain [`Compliance`](self) contract instance.

See the [wrapper's documentation](`ComplianceInstance`) for more details.*/
        #[inline]
        pub const fn new(
            address: alloy_sol_types::private::Address,
            __provider: P,
        ) -> Self {
            Self {
                address,
                provider: __provider,
                _network: ::core::marker::PhantomData,
            }
        }
        /// Returns a reference to the address.
        #[inline]
        pub const fn address(&self) -> &alloy_sol_types::private::Address {
            &self.address
        }
        /// Sets the address.
        #[inline]
        pub fn set_address(&mut self, address: alloy_sol_types::private::Address) {
            self.address = address;
        }
        /// Sets the address and returns `self`.
        pub fn at(mut self, address: alloy_sol_types::private::Address) -> Self {
            self.set_address(address);
            self
        }
        /// Returns a reference to the provider.
        #[inline]
        pub const fn provider(&self) -> &P {
            &self.provider
        }
    }
    impl<P: ::core::clone::Clone, N> ComplianceInstance<&P, N> {
        /// Clones the provider and returns a new instance with the cloned provider.
        #[inline]
        pub fn with_cloned_provider(self) -> ComplianceInstance<P, N> {
            ComplianceInstance {
                address: self.address,
                provider: ::core::clone::Clone::clone(&self.provider),
                _network: ::core::marker::PhantomData,
            }
        }
    }
    /// Function calls.
    impl<
        P: alloy_contract::private::Provider<N>,
        N: alloy_contract::private::Network,
    > ComplianceInstance<P, N> {
        /// Creates a new call builder using this contract instance's provider and address.
        ///
        /// Note that the call can be any function call, not just those defined in this
        /// contract. Prefer using the other methods for building type-safe contract calls.
        pub fn call_builder<C: alloy_sol_types::SolCall>(
            &self,
            call: &C,
        ) -> alloy_contract::SolCallBuilder<&P, C, N> {
            alloy_contract::SolCallBuilder::new_sol(&self.provider, &self.address, call)
        }
    }
    /// Event filters.
    impl<
        P: alloy_contract::private::Provider<N>,
        N: alloy_contract::private::Network,
    > ComplianceInstance<P, N> {
        /// Creates a new event filter using this contract instance's provider and address.
        ///
        /// Note that the type can be any event, not just those defined in this contract.
        /// Prefer using the other methods for building type-safe event filters.
        pub fn event_filter<E: alloy_sol_types::SolEvent>(
            &self,
        ) -> alloy_contract::Event<&P, E, N> {
            alloy_contract::Event::new_sol(&self.provider, &self.address)
        }
    }
}
///Module containing a contract's types and functions.
/**

```solidity
library Delta {
    struct Point { uint256 x; uint256 y; }
}
```*/
#[allow(
    non_camel_case_types,
    non_snake_case,
    clippy::pub_underscore_fields,
    clippy::style,
    clippy::empty_structs_with_brackets
)]
pub mod Delta {
    use super::*;
    use alloy::sol_types as alloy_sol_types;
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**```solidity
struct Point { uint256 x; uint256 y; }
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct Point {
        #[allow(missing_docs)]
        pub x: alloy::sol_types::private::primitives::aliases::U256,
        #[allow(missing_docs)]
        pub y: alloy::sol_types::private::primitives::aliases::U256,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (
            alloy::sol_types::sol_data::Uint<256>,
            alloy::sol_types::sol_data::Uint<256>,
        );
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (
            alloy::sol_types::private::primitives::aliases::U256,
            alloy::sol_types::private::primitives::aliases::U256,
        );
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<Point> for UnderlyingRustTuple<'_> {
            fn from(value: Point) -> Self {
                (value.x, value.y)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for Point {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self { x: tuple.0, y: tuple.1 }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolValue for Point {
            type SolType = Self;
        }
        #[automatically_derived]
        impl alloy_sol_types::private::SolTypeValue<Self> for Point {
            #[inline]
            fn stv_to_tokens(&self) -> <Self as alloy_sol_types::SolType>::Token<'_> {
                (
                    <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::SolType>::tokenize(&self.x),
                    <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::SolType>::tokenize(&self.y),
                )
            }
            #[inline]
            fn stv_abi_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encoded_size(&tuple)
            }
            #[inline]
            fn stv_eip712_data_word(&self) -> alloy_sol_types::Word {
                <Self as alloy_sol_types::SolStruct>::eip712_hash_struct(self)
            }
            #[inline]
            fn stv_abi_encode_packed_to(
                &self,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encode_packed_to(&tuple, out)
            }
            #[inline]
            fn stv_abi_packed_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_packed_encoded_size(&tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolType for Point {
            type RustType = Self;
            type Token<'a> = <UnderlyingSolTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SOL_NAME: &'static str = <Self as alloy_sol_types::SolStruct>::NAME;
            const ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::ENCODED_SIZE;
            const PACKED_ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE;
            #[inline]
            fn valid_token(token: &Self::Token<'_>) -> bool {
                <UnderlyingSolTuple<'_> as alloy_sol_types::SolType>::valid_token(token)
            }
            #[inline]
            fn detokenize(token: Self::Token<'_>) -> Self::RustType {
                let tuple = <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::detokenize(token);
                <Self as ::core::convert::From<UnderlyingRustTuple<'_>>>::from(tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolStruct for Point {
            const NAME: &'static str = "Point";
            #[inline]
            fn eip712_root_type() -> alloy_sol_types::private::Cow<'static, str> {
                alloy_sol_types::private::Cow::Borrowed("Point(uint256 x,uint256 y)")
            }
            #[inline]
            fn eip712_components() -> alloy_sol_types::private::Vec<
                alloy_sol_types::private::Cow<'static, str>,
            > {
                alloy_sol_types::private::Vec::new()
            }
            #[inline]
            fn eip712_encode_type() -> alloy_sol_types::private::Cow<'static, str> {
                <Self as alloy_sol_types::SolStruct>::eip712_root_type()
            }
            #[inline]
            fn eip712_encode_data(&self) -> alloy_sol_types::private::Vec<u8> {
                [
                    <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::SolType>::eip712_data_word(&self.x)
                        .0,
                    <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::SolType>::eip712_data_word(&self.y)
                        .0,
                ]
                    .concat()
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::EventTopic for Point {
            #[inline]
            fn topic_preimage_length(rust: &Self::RustType) -> usize {
                0usize
                    + <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::EventTopic>::topic_preimage_length(&rust.x)
                    + <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::EventTopic>::topic_preimage_length(&rust.y)
            }
            #[inline]
            fn encode_topic_preimage(
                rust: &Self::RustType,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                out.reserve(
                    <Self as alloy_sol_types::EventTopic>::topic_preimage_length(rust),
                );
                <alloy::sol_types::sol_data::Uint<
                    256,
                > as alloy_sol_types::EventTopic>::encode_topic_preimage(&rust.x, out);
                <alloy::sol_types::sol_data::Uint<
                    256,
                > as alloy_sol_types::EventTopic>::encode_topic_preimage(&rust.y, out);
            }
            #[inline]
            fn encode_topic(
                rust: &Self::RustType,
            ) -> alloy_sol_types::abi::token::WordToken {
                let mut out = alloy_sol_types::private::Vec::new();
                <Self as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    rust,
                    &mut out,
                );
                alloy_sol_types::abi::token::WordToken(
                    alloy_sol_types::private::keccak256(out),
                )
            }
        }
    };
    use alloy::contract as alloy_contract;
    /**Creates a new wrapper around an on-chain [`Delta`](self) contract instance.

See the [wrapper's documentation](`DeltaInstance`) for more details.*/
    #[inline]
    pub const fn new<
        P: alloy_contract::private::Provider<N>,
        N: alloy_contract::private::Network,
    >(address: alloy_sol_types::private::Address, __provider: P) -> DeltaInstance<P, N> {
        DeltaInstance::<P, N>::new(address, __provider)
    }
    /**A [`Delta`](self) instance.

Contains type-safe methods for interacting with an on-chain instance of the
[`Delta`](self) contract located at a given `address`, using a given
provider `P`.

If the contract bytecode is available (see the [`sol!`](alloy_sol_types::sol!)
documentation on how to provide it), the `deploy` and `deploy_builder` methods can
be used to deploy a new instance of the contract.

See the [module-level documentation](self) for all the available methods.*/
    #[derive(Clone)]
    pub struct DeltaInstance<P, N = alloy_contract::private::Ethereum> {
        address: alloy_sol_types::private::Address,
        provider: P,
        _network: ::core::marker::PhantomData<N>,
    }
    #[automatically_derived]
    impl<P, N> ::core::fmt::Debug for DeltaInstance<P, N> {
        #[inline]
        fn fmt(&self, f: &mut ::core::fmt::Formatter<'_>) -> ::core::fmt::Result {
            f.debug_tuple("DeltaInstance").field(&self.address).finish()
        }
    }
    /// Instantiation and getters/setters.
    impl<
        P: alloy_contract::private::Provider<N>,
        N: alloy_contract::private::Network,
    > DeltaInstance<P, N> {
        /**Creates a new wrapper around an on-chain [`Delta`](self) contract instance.

See the [wrapper's documentation](`DeltaInstance`) for more details.*/
        #[inline]
        pub const fn new(
            address: alloy_sol_types::private::Address,
            __provider: P,
        ) -> Self {
            Self {
                address,
                provider: __provider,
                _network: ::core::marker::PhantomData,
            }
        }
        /// Returns a reference to the address.
        #[inline]
        pub const fn address(&self) -> &alloy_sol_types::private::Address {
            &self.address
        }
        /// Sets the address.
        #[inline]
        pub fn set_address(&mut self, address: alloy_sol_types::private::Address) {
            self.address = address;
        }
        /// Sets the address and returns `self`.
        pub fn at(mut self, address: alloy_sol_types::private::Address) -> Self {
            self.set_address(address);
            self
        }
        /// Returns a reference to the provider.
        #[inline]
        pub const fn provider(&self) -> &P {
            &self.provider
        }
    }
    impl<P: ::core::clone::Clone, N> DeltaInstance<&P, N> {
        /// Clones the provider and returns a new instance with the cloned provider.
        #[inline]
        pub fn with_cloned_provider(self) -> DeltaInstance<P, N> {
            DeltaInstance {
                address: self.address,
                provider: ::core::clone::Clone::clone(&self.provider),
                _network: ::core::marker::PhantomData,
            }
        }
    }
    /// Function calls.
    impl<
        P: alloy_contract::private::Provider<N>,
        N: alloy_contract::private::Network,
    > DeltaInstance<P, N> {
        /// Creates a new call builder using this contract instance's provider and address.
        ///
        /// Note that the call can be any function call, not just those defined in this
        /// contract. Prefer using the other methods for building type-safe contract calls.
        pub fn call_builder<C: alloy_sol_types::SolCall>(
            &self,
            call: &C,
        ) -> alloy_contract::SolCallBuilder<&P, C, N> {
            alloy_contract::SolCallBuilder::new_sol(&self.provider, &self.address, call)
        }
    }
    /// Event filters.
    impl<
        P: alloy_contract::private::Provider<N>,
        N: alloy_contract::private::Network,
    > DeltaInstance<P, N> {
        /// Creates a new event filter using this contract instance's provider and address.
        ///
        /// Note that the type can be any event, not just those defined in this contract.
        /// Prefer using the other methods for building type-safe event filters.
        pub fn event_filter<E: alloy_sol_types::SolEvent>(
            &self,
        ) -> alloy_contract::Event<&P, E, N> {
            alloy_contract::Event::new_sol(&self.provider, &self.address)
        }
    }
}
///Module containing a contract's types and functions.
/**

```solidity
library Logic {
    type DeletionCriterion is uint8;
    struct AppData { ExpirableBlob[] resourcePayload; ExpirableBlob[] discoveryPayload; ExpirableBlob[] externalPayload; ExpirableBlob[] applicationPayload; }
    struct ExpirableBlob { DeletionCriterion deletionCriterion; bytes blob; }
    struct VerifierInput { bytes32 tag; bytes32 verifyingKey; AppData appData; bytes proof; }
}
```*/
#[allow(
    non_camel_case_types,
    non_snake_case,
    clippy::pub_underscore_fields,
    clippy::style,
    clippy::empty_structs_with_brackets
)]
pub mod Logic {
    use super::*;
    use alloy::sol_types as alloy_sol_types;
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct DeletionCriterion(u8);
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[automatically_derived]
        impl alloy_sol_types::private::SolTypeValue<DeletionCriterion> for u8 {
            #[inline]
            fn stv_to_tokens(
                &self,
            ) -> <alloy::sol_types::sol_data::Uint<
                8,
            > as alloy_sol_types::SolType>::Token<'_> {
                alloy_sol_types::private::SolTypeValue::<
                    alloy::sol_types::sol_data::Uint<8>,
                >::stv_to_tokens(self)
            }
            #[inline]
            fn stv_eip712_data_word(&self) -> alloy_sol_types::Word {
                <alloy::sol_types::sol_data::Uint<
                    8,
                > as alloy_sol_types::SolType>::tokenize(self)
                    .0
            }
            #[inline]
            fn stv_abi_encode_packed_to(
                &self,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                <alloy::sol_types::sol_data::Uint<
                    8,
                > as alloy_sol_types::SolType>::abi_encode_packed_to(self, out)
            }
            #[inline]
            fn stv_abi_packed_encoded_size(&self) -> usize {
                <alloy::sol_types::sol_data::Uint<
                    8,
                > as alloy_sol_types::SolType>::abi_encoded_size(self)
            }
        }
        impl DeletionCriterion {
            /// The Solidity type name.
            pub const NAME: &'static str = stringify!(@ name);
            /// Convert from the underlying value type.
            #[inline]
            pub const fn from_underlying(value: u8) -> Self {
                Self(value)
            }
            /// Return the underlying value.
            #[inline]
            pub const fn into_underlying(self) -> u8 {
                self.0
            }
            /// Return the single encoding of this value, delegating to the
            /// underlying type.
            #[inline]
            pub fn abi_encode(&self) -> alloy_sol_types::private::Vec<u8> {
                <Self as alloy_sol_types::SolType>::abi_encode(&self.0)
            }
            /// Return the packed encoding of this value, delegating to the
            /// underlying type.
            #[inline]
            pub fn abi_encode_packed(&self) -> alloy_sol_types::private::Vec<u8> {
                <Self as alloy_sol_types::SolType>::abi_encode_packed(&self.0)
            }
        }
        #[automatically_derived]
        impl From<u8> for DeletionCriterion {
            fn from(value: u8) -> Self {
                Self::from_underlying(value)
            }
        }
        #[automatically_derived]
        impl From<DeletionCriterion> for u8 {
            fn from(value: DeletionCriterion) -> Self {
                value.into_underlying()
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolType for DeletionCriterion {
            type RustType = u8;
            type Token<'a> = <alloy::sol_types::sol_data::Uint<
                8,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SOL_NAME: &'static str = Self::NAME;
            const ENCODED_SIZE: Option<usize> = <alloy::sol_types::sol_data::Uint<
                8,
            > as alloy_sol_types::SolType>::ENCODED_SIZE;
            const PACKED_ENCODED_SIZE: Option<usize> = <alloy::sol_types::sol_data::Uint<
                8,
            > as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE;
            #[inline]
            fn valid_token(token: &Self::Token<'_>) -> bool {
                Self::type_check(token).is_ok()
            }
            #[inline]
            fn type_check(token: &Self::Token<'_>) -> alloy_sol_types::Result<()> {
                <alloy::sol_types::sol_data::Uint<
                    8,
                > as alloy_sol_types::SolType>::type_check(token)
            }
            #[inline]
            fn detokenize(token: Self::Token<'_>) -> Self::RustType {
                <alloy::sol_types::sol_data::Uint<
                    8,
                > as alloy_sol_types::SolType>::detokenize(token)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::EventTopic for DeletionCriterion {
            #[inline]
            fn topic_preimage_length(rust: &Self::RustType) -> usize {
                <alloy::sol_types::sol_data::Uint<
                    8,
                > as alloy_sol_types::EventTopic>::topic_preimage_length(rust)
            }
            #[inline]
            fn encode_topic_preimage(
                rust: &Self::RustType,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                <alloy::sol_types::sol_data::Uint<
                    8,
                > as alloy_sol_types::EventTopic>::encode_topic_preimage(rust, out)
            }
            #[inline]
            fn encode_topic(
                rust: &Self::RustType,
            ) -> alloy_sol_types::abi::token::WordToken {
                <alloy::sol_types::sol_data::Uint<
                    8,
                > as alloy_sol_types::EventTopic>::encode_topic(rust)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**```solidity
struct AppData { ExpirableBlob[] resourcePayload; ExpirableBlob[] discoveryPayload; ExpirableBlob[] externalPayload; ExpirableBlob[] applicationPayload; }
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct AppData {
        #[allow(missing_docs)]
        pub resourcePayload: alloy::sol_types::private::Vec<
            <ExpirableBlob as alloy::sol_types::SolType>::RustType,
        >,
        #[allow(missing_docs)]
        pub discoveryPayload: alloy::sol_types::private::Vec<
            <ExpirableBlob as alloy::sol_types::SolType>::RustType,
        >,
        #[allow(missing_docs)]
        pub externalPayload: alloy::sol_types::private::Vec<
            <ExpirableBlob as alloy::sol_types::SolType>::RustType,
        >,
        #[allow(missing_docs)]
        pub applicationPayload: alloy::sol_types::private::Vec<
            <ExpirableBlob as alloy::sol_types::SolType>::RustType,
        >,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (
            alloy::sol_types::sol_data::Array<ExpirableBlob>,
            alloy::sol_types::sol_data::Array<ExpirableBlob>,
            alloy::sol_types::sol_data::Array<ExpirableBlob>,
            alloy::sol_types::sol_data::Array<ExpirableBlob>,
        );
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (
            alloy::sol_types::private::Vec<
                <ExpirableBlob as alloy::sol_types::SolType>::RustType,
            >,
            alloy::sol_types::private::Vec<
                <ExpirableBlob as alloy::sol_types::SolType>::RustType,
            >,
            alloy::sol_types::private::Vec<
                <ExpirableBlob as alloy::sol_types::SolType>::RustType,
            >,
            alloy::sol_types::private::Vec<
                <ExpirableBlob as alloy::sol_types::SolType>::RustType,
            >,
        );
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<AppData> for UnderlyingRustTuple<'_> {
            fn from(value: AppData) -> Self {
                (
                    value.resourcePayload,
                    value.discoveryPayload,
                    value.externalPayload,
                    value.applicationPayload,
                )
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for AppData {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self {
                    resourcePayload: tuple.0,
                    discoveryPayload: tuple.1,
                    externalPayload: tuple.2,
                    applicationPayload: tuple.3,
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolValue for AppData {
            type SolType = Self;
        }
        #[automatically_derived]
        impl alloy_sol_types::private::SolTypeValue<Self> for AppData {
            #[inline]
            fn stv_to_tokens(&self) -> <Self as alloy_sol_types::SolType>::Token<'_> {
                (
                    <alloy::sol_types::sol_data::Array<
                        ExpirableBlob,
                    > as alloy_sol_types::SolType>::tokenize(&self.resourcePayload),
                    <alloy::sol_types::sol_data::Array<
                        ExpirableBlob,
                    > as alloy_sol_types::SolType>::tokenize(&self.discoveryPayload),
                    <alloy::sol_types::sol_data::Array<
                        ExpirableBlob,
                    > as alloy_sol_types::SolType>::tokenize(&self.externalPayload),
                    <alloy::sol_types::sol_data::Array<
                        ExpirableBlob,
                    > as alloy_sol_types::SolType>::tokenize(&self.applicationPayload),
                )
            }
            #[inline]
            fn stv_abi_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encoded_size(&tuple)
            }
            #[inline]
            fn stv_eip712_data_word(&self) -> alloy_sol_types::Word {
                <Self as alloy_sol_types::SolStruct>::eip712_hash_struct(self)
            }
            #[inline]
            fn stv_abi_encode_packed_to(
                &self,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encode_packed_to(&tuple, out)
            }
            #[inline]
            fn stv_abi_packed_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_packed_encoded_size(&tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolType for AppData {
            type RustType = Self;
            type Token<'a> = <UnderlyingSolTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SOL_NAME: &'static str = <Self as alloy_sol_types::SolStruct>::NAME;
            const ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::ENCODED_SIZE;
            const PACKED_ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE;
            #[inline]
            fn valid_token(token: &Self::Token<'_>) -> bool {
                <UnderlyingSolTuple<'_> as alloy_sol_types::SolType>::valid_token(token)
            }
            #[inline]
            fn detokenize(token: Self::Token<'_>) -> Self::RustType {
                let tuple = <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::detokenize(token);
                <Self as ::core::convert::From<UnderlyingRustTuple<'_>>>::from(tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolStruct for AppData {
            const NAME: &'static str = "AppData";
            #[inline]
            fn eip712_root_type() -> alloy_sol_types::private::Cow<'static, str> {
                alloy_sol_types::private::Cow::Borrowed(
                    "AppData(ExpirableBlob[] resourcePayload,ExpirableBlob[] discoveryPayload,ExpirableBlob[] externalPayload,ExpirableBlob[] applicationPayload)",
                )
            }
            #[inline]
            fn eip712_components() -> alloy_sol_types::private::Vec<
                alloy_sol_types::private::Cow<'static, str>,
            > {
                let mut components = alloy_sol_types::private::Vec::with_capacity(4);
                components
                    .push(
                        <ExpirableBlob as alloy_sol_types::SolStruct>::eip712_root_type(),
                    );
                components
                    .extend(
                        <ExpirableBlob as alloy_sol_types::SolStruct>::eip712_components(),
                    );
                components
                    .push(
                        <ExpirableBlob as alloy_sol_types::SolStruct>::eip712_root_type(),
                    );
                components
                    .extend(
                        <ExpirableBlob as alloy_sol_types::SolStruct>::eip712_components(),
                    );
                components
                    .push(
                        <ExpirableBlob as alloy_sol_types::SolStruct>::eip712_root_type(),
                    );
                components
                    .extend(
                        <ExpirableBlob as alloy_sol_types::SolStruct>::eip712_components(),
                    );
                components
                    .push(
                        <ExpirableBlob as alloy_sol_types::SolStruct>::eip712_root_type(),
                    );
                components
                    .extend(
                        <ExpirableBlob as alloy_sol_types::SolStruct>::eip712_components(),
                    );
                components
            }
            #[inline]
            fn eip712_encode_data(&self) -> alloy_sol_types::private::Vec<u8> {
                [
                    <alloy::sol_types::sol_data::Array<
                        ExpirableBlob,
                    > as alloy_sol_types::SolType>::eip712_data_word(
                            &self.resourcePayload,
                        )
                        .0,
                    <alloy::sol_types::sol_data::Array<
                        ExpirableBlob,
                    > as alloy_sol_types::SolType>::eip712_data_word(
                            &self.discoveryPayload,
                        )
                        .0,
                    <alloy::sol_types::sol_data::Array<
                        ExpirableBlob,
                    > as alloy_sol_types::SolType>::eip712_data_word(
                            &self.externalPayload,
                        )
                        .0,
                    <alloy::sol_types::sol_data::Array<
                        ExpirableBlob,
                    > as alloy_sol_types::SolType>::eip712_data_word(
                            &self.applicationPayload,
                        )
                        .0,
                ]
                    .concat()
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::EventTopic for AppData {
            #[inline]
            fn topic_preimage_length(rust: &Self::RustType) -> usize {
                0usize
                    + <alloy::sol_types::sol_data::Array<
                        ExpirableBlob,
                    > as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.resourcePayload,
                    )
                    + <alloy::sol_types::sol_data::Array<
                        ExpirableBlob,
                    > as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.discoveryPayload,
                    )
                    + <alloy::sol_types::sol_data::Array<
                        ExpirableBlob,
                    > as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.externalPayload,
                    )
                    + <alloy::sol_types::sol_data::Array<
                        ExpirableBlob,
                    > as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.applicationPayload,
                    )
            }
            #[inline]
            fn encode_topic_preimage(
                rust: &Self::RustType,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                out.reserve(
                    <Self as alloy_sol_types::EventTopic>::topic_preimage_length(rust),
                );
                <alloy::sol_types::sol_data::Array<
                    ExpirableBlob,
                > as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.resourcePayload,
                    out,
                );
                <alloy::sol_types::sol_data::Array<
                    ExpirableBlob,
                > as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.discoveryPayload,
                    out,
                );
                <alloy::sol_types::sol_data::Array<
                    ExpirableBlob,
                > as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.externalPayload,
                    out,
                );
                <alloy::sol_types::sol_data::Array<
                    ExpirableBlob,
                > as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.applicationPayload,
                    out,
                );
            }
            #[inline]
            fn encode_topic(
                rust: &Self::RustType,
            ) -> alloy_sol_types::abi::token::WordToken {
                let mut out = alloy_sol_types::private::Vec::new();
                <Self as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    rust,
                    &mut out,
                );
                alloy_sol_types::abi::token::WordToken(
                    alloy_sol_types::private::keccak256(out),
                )
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**```solidity
struct ExpirableBlob { DeletionCriterion deletionCriterion; bytes blob; }
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct ExpirableBlob {
        #[allow(missing_docs)]
        pub deletionCriterion: <DeletionCriterion as alloy::sol_types::SolType>::RustType,
        #[allow(missing_docs)]
        pub blob: alloy::sol_types::private::Bytes,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (
            DeletionCriterion,
            alloy::sol_types::sol_data::Bytes,
        );
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (
            <DeletionCriterion as alloy::sol_types::SolType>::RustType,
            alloy::sol_types::private::Bytes,
        );
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<ExpirableBlob> for UnderlyingRustTuple<'_> {
            fn from(value: ExpirableBlob) -> Self {
                (value.deletionCriterion, value.blob)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for ExpirableBlob {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self {
                    deletionCriterion: tuple.0,
                    blob: tuple.1,
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolValue for ExpirableBlob {
            type SolType = Self;
        }
        #[automatically_derived]
        impl alloy_sol_types::private::SolTypeValue<Self> for ExpirableBlob {
            #[inline]
            fn stv_to_tokens(&self) -> <Self as alloy_sol_types::SolType>::Token<'_> {
                (
                    <DeletionCriterion as alloy_sol_types::SolType>::tokenize(
                        &self.deletionCriterion,
                    ),
                    <alloy::sol_types::sol_data::Bytes as alloy_sol_types::SolType>::tokenize(
                        &self.blob,
                    ),
                )
            }
            #[inline]
            fn stv_abi_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encoded_size(&tuple)
            }
            #[inline]
            fn stv_eip712_data_word(&self) -> alloy_sol_types::Word {
                <Self as alloy_sol_types::SolStruct>::eip712_hash_struct(self)
            }
            #[inline]
            fn stv_abi_encode_packed_to(
                &self,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encode_packed_to(&tuple, out)
            }
            #[inline]
            fn stv_abi_packed_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_packed_encoded_size(&tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolType for ExpirableBlob {
            type RustType = Self;
            type Token<'a> = <UnderlyingSolTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SOL_NAME: &'static str = <Self as alloy_sol_types::SolStruct>::NAME;
            const ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::ENCODED_SIZE;
            const PACKED_ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE;
            #[inline]
            fn valid_token(token: &Self::Token<'_>) -> bool {
                <UnderlyingSolTuple<'_> as alloy_sol_types::SolType>::valid_token(token)
            }
            #[inline]
            fn detokenize(token: Self::Token<'_>) -> Self::RustType {
                let tuple = <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::detokenize(token);
                <Self as ::core::convert::From<UnderlyingRustTuple<'_>>>::from(tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolStruct for ExpirableBlob {
            const NAME: &'static str = "ExpirableBlob";
            #[inline]
            fn eip712_root_type() -> alloy_sol_types::private::Cow<'static, str> {
                alloy_sol_types::private::Cow::Borrowed(
                    "ExpirableBlob(uint8 deletionCriterion,bytes blob)",
                )
            }
            #[inline]
            fn eip712_components() -> alloy_sol_types::private::Vec<
                alloy_sol_types::private::Cow<'static, str>,
            > {
                alloy_sol_types::private::Vec::new()
            }
            #[inline]
            fn eip712_encode_type() -> alloy_sol_types::private::Cow<'static, str> {
                <Self as alloy_sol_types::SolStruct>::eip712_root_type()
            }
            #[inline]
            fn eip712_encode_data(&self) -> alloy_sol_types::private::Vec<u8> {
                [
                    <DeletionCriterion as alloy_sol_types::SolType>::eip712_data_word(
                            &self.deletionCriterion,
                        )
                        .0,
                    <alloy::sol_types::sol_data::Bytes as alloy_sol_types::SolType>::eip712_data_word(
                            &self.blob,
                        )
                        .0,
                ]
                    .concat()
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::EventTopic for ExpirableBlob {
            #[inline]
            fn topic_preimage_length(rust: &Self::RustType) -> usize {
                0usize
                    + <DeletionCriterion as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.deletionCriterion,
                    )
                    + <alloy::sol_types::sol_data::Bytes as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.blob,
                    )
            }
            #[inline]
            fn encode_topic_preimage(
                rust: &Self::RustType,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                out.reserve(
                    <Self as alloy_sol_types::EventTopic>::topic_preimage_length(rust),
                );
                <DeletionCriterion as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.deletionCriterion,
                    out,
                );
                <alloy::sol_types::sol_data::Bytes as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.blob,
                    out,
                );
            }
            #[inline]
            fn encode_topic(
                rust: &Self::RustType,
            ) -> alloy_sol_types::abi::token::WordToken {
                let mut out = alloy_sol_types::private::Vec::new();
                <Self as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    rust,
                    &mut out,
                );
                alloy_sol_types::abi::token::WordToken(
                    alloy_sol_types::private::keccak256(out),
                )
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**```solidity
struct VerifierInput { bytes32 tag; bytes32 verifyingKey; AppData appData; bytes proof; }
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct VerifierInput {
        #[allow(missing_docs)]
        pub tag: alloy::sol_types::private::FixedBytes<32>,
        #[allow(missing_docs)]
        pub verifyingKey: alloy::sol_types::private::FixedBytes<32>,
        #[allow(missing_docs)]
        pub appData: <AppData as alloy::sol_types::SolType>::RustType,
        #[allow(missing_docs)]
        pub proof: alloy::sol_types::private::Bytes,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (
            alloy::sol_types::sol_data::FixedBytes<32>,
            alloy::sol_types::sol_data::FixedBytes<32>,
            AppData,
            alloy::sol_types::sol_data::Bytes,
        );
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (
            alloy::sol_types::private::FixedBytes<32>,
            alloy::sol_types::private::FixedBytes<32>,
            <AppData as alloy::sol_types::SolType>::RustType,
            alloy::sol_types::private::Bytes,
        );
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<VerifierInput> for UnderlyingRustTuple<'_> {
            fn from(value: VerifierInput) -> Self {
                (value.tag, value.verifyingKey, value.appData, value.proof)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for VerifierInput {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self {
                    tag: tuple.0,
                    verifyingKey: tuple.1,
                    appData: tuple.2,
                    proof: tuple.3,
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolValue for VerifierInput {
            type SolType = Self;
        }
        #[automatically_derived]
        impl alloy_sol_types::private::SolTypeValue<Self> for VerifierInput {
            #[inline]
            fn stv_to_tokens(&self) -> <Self as alloy_sol_types::SolType>::Token<'_> {
                (
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.tag),
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.verifyingKey),
                    <AppData as alloy_sol_types::SolType>::tokenize(&self.appData),
                    <alloy::sol_types::sol_data::Bytes as alloy_sol_types::SolType>::tokenize(
                        &self.proof,
                    ),
                )
            }
            #[inline]
            fn stv_abi_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encoded_size(&tuple)
            }
            #[inline]
            fn stv_eip712_data_word(&self) -> alloy_sol_types::Word {
                <Self as alloy_sol_types::SolStruct>::eip712_hash_struct(self)
            }
            #[inline]
            fn stv_abi_encode_packed_to(
                &self,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encode_packed_to(&tuple, out)
            }
            #[inline]
            fn stv_abi_packed_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_packed_encoded_size(&tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolType for VerifierInput {
            type RustType = Self;
            type Token<'a> = <UnderlyingSolTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SOL_NAME: &'static str = <Self as alloy_sol_types::SolStruct>::NAME;
            const ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::ENCODED_SIZE;
            const PACKED_ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE;
            #[inline]
            fn valid_token(token: &Self::Token<'_>) -> bool {
                <UnderlyingSolTuple<'_> as alloy_sol_types::SolType>::valid_token(token)
            }
            #[inline]
            fn detokenize(token: Self::Token<'_>) -> Self::RustType {
                let tuple = <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::detokenize(token);
                <Self as ::core::convert::From<UnderlyingRustTuple<'_>>>::from(tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolStruct for VerifierInput {
            const NAME: &'static str = "VerifierInput";
            #[inline]
            fn eip712_root_type() -> alloy_sol_types::private::Cow<'static, str> {
                alloy_sol_types::private::Cow::Borrowed(
                    "VerifierInput(bytes32 tag,bytes32 verifyingKey,AppData appData,bytes proof)",
                )
            }
            #[inline]
            fn eip712_components() -> alloy_sol_types::private::Vec<
                alloy_sol_types::private::Cow<'static, str>,
            > {
                let mut components = alloy_sol_types::private::Vec::with_capacity(1);
                components
                    .push(<AppData as alloy_sol_types::SolStruct>::eip712_root_type());
                components
                    .extend(
                        <AppData as alloy_sol_types::SolStruct>::eip712_components(),
                    );
                components
            }
            #[inline]
            fn eip712_encode_data(&self) -> alloy_sol_types::private::Vec<u8> {
                [
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::eip712_data_word(&self.tag)
                        .0,
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::eip712_data_word(&self.verifyingKey)
                        .0,
                    <AppData as alloy_sol_types::SolType>::eip712_data_word(
                            &self.appData,
                        )
                        .0,
                    <alloy::sol_types::sol_data::Bytes as alloy_sol_types::SolType>::eip712_data_word(
                            &self.proof,
                        )
                        .0,
                ]
                    .concat()
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::EventTopic for VerifierInput {
            #[inline]
            fn topic_preimage_length(rust: &Self::RustType) -> usize {
                0usize
                    + <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::EventTopic>::topic_preimage_length(&rust.tag)
                    + <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.verifyingKey,
                    )
                    + <AppData as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.appData,
                    )
                    + <alloy::sol_types::sol_data::Bytes as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.proof,
                    )
            }
            #[inline]
            fn encode_topic_preimage(
                rust: &Self::RustType,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                out.reserve(
                    <Self as alloy_sol_types::EventTopic>::topic_preimage_length(rust),
                );
                <alloy::sol_types::sol_data::FixedBytes<
                    32,
                > as alloy_sol_types::EventTopic>::encode_topic_preimage(&rust.tag, out);
                <alloy::sol_types::sol_data::FixedBytes<
                    32,
                > as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.verifyingKey,
                    out,
                );
                <AppData as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.appData,
                    out,
                );
                <alloy::sol_types::sol_data::Bytes as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.proof,
                    out,
                );
            }
            #[inline]
            fn encode_topic(
                rust: &Self::RustType,
            ) -> alloy_sol_types::abi::token::WordToken {
                let mut out = alloy_sol_types::private::Vec::new();
                <Self as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    rust,
                    &mut out,
                );
                alloy_sol_types::abi::token::WordToken(
                    alloy_sol_types::private::keccak256(out),
                )
            }
        }
    };
    use alloy::contract as alloy_contract;
    /**Creates a new wrapper around an on-chain [`Logic`](self) contract instance.

See the [wrapper's documentation](`LogicInstance`) for more details.*/
    #[inline]
    pub const fn new<
        P: alloy_contract::private::Provider<N>,
        N: alloy_contract::private::Network,
    >(address: alloy_sol_types::private::Address, __provider: P) -> LogicInstance<P, N> {
        LogicInstance::<P, N>::new(address, __provider)
    }
    /**A [`Logic`](self) instance.

Contains type-safe methods for interacting with an on-chain instance of the
[`Logic`](self) contract located at a given `address`, using a given
provider `P`.

If the contract bytecode is available (see the [`sol!`](alloy_sol_types::sol!)
documentation on how to provide it), the `deploy` and `deploy_builder` methods can
be used to deploy a new instance of the contract.

See the [module-level documentation](self) for all the available methods.*/
    #[derive(Clone)]
    pub struct LogicInstance<P, N = alloy_contract::private::Ethereum> {
        address: alloy_sol_types::private::Address,
        provider: P,
        _network: ::core::marker::PhantomData<N>,
    }
    #[automatically_derived]
    impl<P, N> ::core::fmt::Debug for LogicInstance<P, N> {
        #[inline]
        fn fmt(&self, f: &mut ::core::fmt::Formatter<'_>) -> ::core::fmt::Result {
            f.debug_tuple("LogicInstance").field(&self.address).finish()
        }
    }
    /// Instantiation and getters/setters.
    impl<
        P: alloy_contract::private::Provider<N>,
        N: alloy_contract::private::Network,
    > LogicInstance<P, N> {
        /**Creates a new wrapper around an on-chain [`Logic`](self) contract instance.

See the [wrapper's documentation](`LogicInstance`) for more details.*/
        #[inline]
        pub const fn new(
            address: alloy_sol_types::private::Address,
            __provider: P,
        ) -> Self {
            Self {
                address,
                provider: __provider,
                _network: ::core::marker::PhantomData,
            }
        }
        /// Returns a reference to the address.
        #[inline]
        pub const fn address(&self) -> &alloy_sol_types::private::Address {
            &self.address
        }
        /// Sets the address.
        #[inline]
        pub fn set_address(&mut self, address: alloy_sol_types::private::Address) {
            self.address = address;
        }
        /// Sets the address and returns `self`.
        pub fn at(mut self, address: alloy_sol_types::private::Address) -> Self {
            self.set_address(address);
            self
        }
        /// Returns a reference to the provider.
        #[inline]
        pub const fn provider(&self) -> &P {
            &self.provider
        }
    }
    impl<P: ::core::clone::Clone, N> LogicInstance<&P, N> {
        /// Clones the provider and returns a new instance with the cloned provider.
        #[inline]
        pub fn with_cloned_provider(self) -> LogicInstance<P, N> {
            LogicInstance {
                address: self.address,
                provider: ::core::clone::Clone::clone(&self.provider),
                _network: ::core::marker::PhantomData,
            }
        }
    }
    /// Function calls.
    impl<
        P: alloy_contract::private::Provider<N>,
        N: alloy_contract::private::Network,
    > LogicInstance<P, N> {
        /// Creates a new call builder using this contract instance's provider and address.
        ///
        /// Note that the call can be any function call, not just those defined in this
        /// contract. Prefer using the other methods for building type-safe contract calls.
        pub fn call_builder<C: alloy_sol_types::SolCall>(
            &self,
            call: &C,
        ) -> alloy_contract::SolCallBuilder<&P, C, N> {
            alloy_contract::SolCallBuilder::new_sol(&self.provider, &self.address, call)
        }
    }
    /// Event filters.
    impl<
        P: alloy_contract::private::Provider<N>,
        N: alloy_contract::private::Network,
    > LogicInstance<P, N> {
        /// Creates a new event filter using this contract instance's provider and address.
        ///
        /// Note that the type can be any event, not just those defined in this contract.
        /// Prefer using the other methods for building type-safe event filters.
        pub fn event_filter<E: alloy_sol_types::SolEvent>(
            &self,
        ) -> alloy_contract::Event<&P, E, N> {
            alloy_contract::Event::new_sol(&self.provider, &self.address)
        }
    }
}
/**

Generated by the following Solidity interface...
```solidity
library Compliance {
    struct ConsumedRefs {
        bytes32 nullifier;
        bytes32 logicRef;
        bytes32 commitmentTreeRoot;
    }
    struct CreatedRefs {
        bytes32 commitment;
        bytes32 logicRef;
    }
    struct Instance {
        ConsumedRefs consumed;
        CreatedRefs created;
        bytes32 unitDeltaX;
        bytes32 unitDeltaY;
    }
    struct VerifierInput {
        bytes proof;
        Instance instance;
    }
}

library Delta {
    struct Point {
        uint256 x;
        uint256 y;
    }
}

library Logic {
    type DeletionCriterion is uint8;
    struct AppData {
        ExpirableBlob[] resourcePayload;
        ExpirableBlob[] discoveryPayload;
        ExpirableBlob[] externalPayload;
        ExpirableBlob[] applicationPayload;
    }
    struct ExpirableBlob {
        DeletionCriterion deletionCriterion;
        bytes blob;
    }
    struct VerifierInput {
        bytes32 tag;
        bytes32 verifyingKey;
        AppData appData;
        bytes proof;
    }
}

interface ProtocolAdapter {
    struct Action {
        Logic.VerifierInput[] logicVerifierInputs;
        Compliance.VerifierInput[] complianceVerifierInputs;
    }
    struct Transaction {
        Action[] actions;
        bytes deltaProof;
        bytes aggregationProof;
    }

    error DeltaMismatch(address expected, address actual);
    error ECDSAInvalidSignature();
    error ECDSAInvalidSignatureLength(uint256 length);
    error ECDSAInvalidSignatureS(bytes32 s);
    error EnforcedPause();
    error ExpectedPause();
    error ForwarderCallOutputMismatch(bytes expected, bytes actual);
    error LogicRefMismatch(bytes32 expected, bytes32 actual);
    error NonExistingRoot(bytes32 root);
    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);
    error PointNotOnCurve(Delta.Point point);
    error PreExistingNullifier(bytes32 nullifier);
    error PreExistingRoot(bytes32 root);
    error ReentrancyGuardReentrantCall();
    error RiscZeroVerifierSelectorMismatch(bytes4 expected, bytes4 actual);
    error RiscZeroVerifierStopped();
    error Simulated(uint256 gasUsed);
    error TagCountMismatch(uint256 expected, uint256 actual);
    error TagNotFound(bytes32 tag);
    error ZeroNotAllowed();

    event ActionExecuted(bytes32 actionTreeRoot, uint256 actionTagCount);
    event ApplicationPayload(bytes32 indexed tag, uint256 index, bytes blob);
    event CommitmentTreeRootAdded(bytes32 root);
    event DiscoveryPayload(bytes32 indexed tag, uint256 index, bytes blob);
    event ExternalPayload(bytes32 indexed tag, uint256 index, bytes blob);
    event ForwarderCallExecuted(address indexed untrustedForwarder, bytes input, bytes output);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Paused(address account);
    event ResourcePayload(bytes32 indexed tag, uint256 index, bytes blob);
    event TransactionExecuted(bytes32[] tags, bytes32[] logicRefs);
    event Unpaused(address account);

    constructor(address riscZeroVerifierRouter, bytes4 riscZeroVerifierSelector, address emergencyStopCaller);

    function commitmentCount() external view returns (uint256 count);
    function commitmentTreeCapacity() external view returns (uint256 capacity);
    function commitmentTreeDepth() external view returns (uint8 depth);
    function commitmentTreeRootAtIndex(uint256 index) external view returns (bytes32 root);
    function commitmentTreeRootCount() external view returns (uint256 count);
    function emergencyStop() external;
    function execute(Transaction memory transaction) external;
    function getRiscZeroVerifierRouter() external view returns (address verifierRouter);
    function getRiscZeroVerifierSelector() external view returns (bytes4 verifierSelector);
    function getVersion() external pure returns (bytes32 version);
    function isCommitmentTreeRootContained(bytes32 root) external view returns (bool isContained);
    function isEmergencyStopped() external view returns (bool isStopped);
    function isNullifierContained(bytes32 nullifier) external view returns (bool isContained);
    function latestCommitmentTreeRoot() external view returns (bytes32 root);
    function nullifierAtIndex(uint256 index) external view returns (bytes32 nullifier);
    function nullifierCount() external view returns (uint256 count);
    function owner() external view returns (address);
    function paused() external view returns (bool);
    function renounceOwnership() external;
    function simulateExecute(Transaction memory transaction, bool skipRiscZeroProofVerification) external;
    function transferOwnership(address newOwner) external;
}
```

...which was generated by the following JSON ABI:
```json
[
  {
    "type": "constructor",
    "inputs": [
      {
        "name": "riscZeroVerifierRouter",
        "type": "address",
        "internalType": "contract RiscZeroVerifierRouter"
      },
      {
        "name": "riscZeroVerifierSelector",
        "type": "bytes4",
        "internalType": "bytes4"
      },
      {
        "name": "emergencyStopCaller",
        "type": "address",
        "internalType": "address"
      }
    ],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "commitmentCount",
    "inputs": [],
    "outputs": [
      {
        "name": "count",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "commitmentTreeCapacity",
    "inputs": [],
    "outputs": [
      {
        "name": "capacity",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "commitmentTreeDepth",
    "inputs": [],
    "outputs": [
      {
        "name": "depth",
        "type": "uint8",
        "internalType": "uint8"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "commitmentTreeRootAtIndex",
    "inputs": [
      {
        "name": "index",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "outputs": [
      {
        "name": "root",
        "type": "bytes32",
        "internalType": "bytes32"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "commitmentTreeRootCount",
    "inputs": [],
    "outputs": [
      {
        "name": "count",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "emergencyStop",
    "inputs": [],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "execute",
    "inputs": [
      {
        "name": "transaction",
        "type": "tuple",
        "internalType": "struct Transaction",
        "components": [
          {
            "name": "actions",
            "type": "tuple[]",
            "internalType": "struct Action[]",
            "components": [
              {
                "name": "logicVerifierInputs",
                "type": "tuple[]",
                "internalType": "struct Logic.VerifierInput[]",
                "components": [
                  {
                    "name": "tag",
                    "type": "bytes32",
                    "internalType": "bytes32"
                  },
                  {
                    "name": "verifyingKey",
                    "type": "bytes32",
                    "internalType": "bytes32"
                  },
                  {
                    "name": "appData",
                    "type": "tuple",
                    "internalType": "struct Logic.AppData",
                    "components": [
                      {
                        "name": "resourcePayload",
                        "type": "tuple[]",
                        "internalType": "struct Logic.ExpirableBlob[]",
                        "components": [
                          {
                            "name": "deletionCriterion",
                            "type": "uint8",
                            "internalType": "enum Logic.DeletionCriterion"
                          },
                          {
                            "name": "blob",
                            "type": "bytes",
                            "internalType": "bytes"
                          }
                        ]
                      },
                      {
                        "name": "discoveryPayload",
                        "type": "tuple[]",
                        "internalType": "struct Logic.ExpirableBlob[]",
                        "components": [
                          {
                            "name": "deletionCriterion",
                            "type": "uint8",
                            "internalType": "enum Logic.DeletionCriterion"
                          },
                          {
                            "name": "blob",
                            "type": "bytes",
                            "internalType": "bytes"
                          }
                        ]
                      },
                      {
                        "name": "externalPayload",
                        "type": "tuple[]",
                        "internalType": "struct Logic.ExpirableBlob[]",
                        "components": [
                          {
                            "name": "deletionCriterion",
                            "type": "uint8",
                            "internalType": "enum Logic.DeletionCriterion"
                          },
                          {
                            "name": "blob",
                            "type": "bytes",
                            "internalType": "bytes"
                          }
                        ]
                      },
                      {
                        "name": "applicationPayload",
                        "type": "tuple[]",
                        "internalType": "struct Logic.ExpirableBlob[]",
                        "components": [
                          {
                            "name": "deletionCriterion",
                            "type": "uint8",
                            "internalType": "enum Logic.DeletionCriterion"
                          },
                          {
                            "name": "blob",
                            "type": "bytes",
                            "internalType": "bytes"
                          }
                        ]
                      }
                    ]
                  },
                  {
                    "name": "proof",
                    "type": "bytes",
                    "internalType": "bytes"
                  }
                ]
              },
              {
                "name": "complianceVerifierInputs",
                "type": "tuple[]",
                "internalType": "struct Compliance.VerifierInput[]",
                "components": [
                  {
                    "name": "proof",
                    "type": "bytes",
                    "internalType": "bytes"
                  },
                  {
                    "name": "instance",
                    "type": "tuple",
                    "internalType": "struct Compliance.Instance",
                    "components": [
                      {
                        "name": "consumed",
                        "type": "tuple",
                        "internalType": "struct Compliance.ConsumedRefs",
                        "components": [
                          {
                            "name": "nullifier",
                            "type": "bytes32",
                            "internalType": "bytes32"
                          },
                          {
                            "name": "logicRef",
                            "type": "bytes32",
                            "internalType": "bytes32"
                          },
                          {
                            "name": "commitmentTreeRoot",
                            "type": "bytes32",
                            "internalType": "bytes32"
                          }
                        ]
                      },
                      {
                        "name": "created",
                        "type": "tuple",
                        "internalType": "struct Compliance.CreatedRefs",
                        "components": [
                          {
                            "name": "commitment",
                            "type": "bytes32",
                            "internalType": "bytes32"
                          },
                          {
                            "name": "logicRef",
                            "type": "bytes32",
                            "internalType": "bytes32"
                          }
                        ]
                      },
                      {
                        "name": "unitDeltaX",
                        "type": "bytes32",
                        "internalType": "bytes32"
                      },
                      {
                        "name": "unitDeltaY",
                        "type": "bytes32",
                        "internalType": "bytes32"
                      }
                    ]
                  }
                ]
              }
            ]
          },
          {
            "name": "deltaProof",
            "type": "bytes",
            "internalType": "bytes"
          },
          {
            "name": "aggregationProof",
            "type": "bytes",
            "internalType": "bytes"
          }
        ]
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "getRiscZeroVerifierRouter",
    "inputs": [],
    "outputs": [
      {
        "name": "verifierRouter",
        "type": "address",
        "internalType": "address"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "getRiscZeroVerifierSelector",
    "inputs": [],
    "outputs": [
      {
        "name": "verifierSelector",
        "type": "bytes4",
        "internalType": "bytes4"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "getVersion",
    "inputs": [],
    "outputs": [
      {
        "name": "version",
        "type": "bytes32",
        "internalType": "bytes32"
      }
    ],
    "stateMutability": "pure"
  },
  {
    "type": "function",
    "name": "isCommitmentTreeRootContained",
    "inputs": [
      {
        "name": "root",
        "type": "bytes32",
        "internalType": "bytes32"
      }
    ],
    "outputs": [
      {
        "name": "isContained",
        "type": "bool",
        "internalType": "bool"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "isEmergencyStopped",
    "inputs": [],
    "outputs": [
      {
        "name": "isStopped",
        "type": "bool",
        "internalType": "bool"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "isNullifierContained",
    "inputs": [
      {
        "name": "nullifier",
        "type": "bytes32",
        "internalType": "bytes32"
      }
    ],
    "outputs": [
      {
        "name": "isContained",
        "type": "bool",
        "internalType": "bool"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "latestCommitmentTreeRoot",
    "inputs": [],
    "outputs": [
      {
        "name": "root",
        "type": "bytes32",
        "internalType": "bytes32"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "nullifierAtIndex",
    "inputs": [
      {
        "name": "index",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "outputs": [
      {
        "name": "nullifier",
        "type": "bytes32",
        "internalType": "bytes32"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "nullifierCount",
    "inputs": [],
    "outputs": [
      {
        "name": "count",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "owner",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "address",
        "internalType": "address"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "paused",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "bool",
        "internalType": "bool"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "renounceOwnership",
    "inputs": [],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "simulateExecute",
    "inputs": [
      {
        "name": "transaction",
        "type": "tuple",
        "internalType": "struct Transaction",
        "components": [
          {
            "name": "actions",
            "type": "tuple[]",
            "internalType": "struct Action[]",
            "components": [
              {
                "name": "logicVerifierInputs",
                "type": "tuple[]",
                "internalType": "struct Logic.VerifierInput[]",
                "components": [
                  {
                    "name": "tag",
                    "type": "bytes32",
                    "internalType": "bytes32"
                  },
                  {
                    "name": "verifyingKey",
                    "type": "bytes32",
                    "internalType": "bytes32"
                  },
                  {
                    "name": "appData",
                    "type": "tuple",
                    "internalType": "struct Logic.AppData",
                    "components": [
                      {
                        "name": "resourcePayload",
                        "type": "tuple[]",
                        "internalType": "struct Logic.ExpirableBlob[]",
                        "components": [
                          {
                            "name": "deletionCriterion",
                            "type": "uint8",
                            "internalType": "enum Logic.DeletionCriterion"
                          },
                          {
                            "name": "blob",
                            "type": "bytes",
                            "internalType": "bytes"
                          }
                        ]
                      },
                      {
                        "name": "discoveryPayload",
                        "type": "tuple[]",
                        "internalType": "struct Logic.ExpirableBlob[]",
                        "components": [
                          {
                            "name": "deletionCriterion",
                            "type": "uint8",
                            "internalType": "enum Logic.DeletionCriterion"
                          },
                          {
                            "name": "blob",
                            "type": "bytes",
                            "internalType": "bytes"
                          }
                        ]
                      },
                      {
                        "name": "externalPayload",
                        "type": "tuple[]",
                        "internalType": "struct Logic.ExpirableBlob[]",
                        "components": [
                          {
                            "name": "deletionCriterion",
                            "type": "uint8",
                            "internalType": "enum Logic.DeletionCriterion"
                          },
                          {
                            "name": "blob",
                            "type": "bytes",
                            "internalType": "bytes"
                          }
                        ]
                      },
                      {
                        "name": "applicationPayload",
                        "type": "tuple[]",
                        "internalType": "struct Logic.ExpirableBlob[]",
                        "components": [
                          {
                            "name": "deletionCriterion",
                            "type": "uint8",
                            "internalType": "enum Logic.DeletionCriterion"
                          },
                          {
                            "name": "blob",
                            "type": "bytes",
                            "internalType": "bytes"
                          }
                        ]
                      }
                    ]
                  },
                  {
                    "name": "proof",
                    "type": "bytes",
                    "internalType": "bytes"
                  }
                ]
              },
              {
                "name": "complianceVerifierInputs",
                "type": "tuple[]",
                "internalType": "struct Compliance.VerifierInput[]",
                "components": [
                  {
                    "name": "proof",
                    "type": "bytes",
                    "internalType": "bytes"
                  },
                  {
                    "name": "instance",
                    "type": "tuple",
                    "internalType": "struct Compliance.Instance",
                    "components": [
                      {
                        "name": "consumed",
                        "type": "tuple",
                        "internalType": "struct Compliance.ConsumedRefs",
                        "components": [
                          {
                            "name": "nullifier",
                            "type": "bytes32",
                            "internalType": "bytes32"
                          },
                          {
                            "name": "logicRef",
                            "type": "bytes32",
                            "internalType": "bytes32"
                          },
                          {
                            "name": "commitmentTreeRoot",
                            "type": "bytes32",
                            "internalType": "bytes32"
                          }
                        ]
                      },
                      {
                        "name": "created",
                        "type": "tuple",
                        "internalType": "struct Compliance.CreatedRefs",
                        "components": [
                          {
                            "name": "commitment",
                            "type": "bytes32",
                            "internalType": "bytes32"
                          },
                          {
                            "name": "logicRef",
                            "type": "bytes32",
                            "internalType": "bytes32"
                          }
                        ]
                      },
                      {
                        "name": "unitDeltaX",
                        "type": "bytes32",
                        "internalType": "bytes32"
                      },
                      {
                        "name": "unitDeltaY",
                        "type": "bytes32",
                        "internalType": "bytes32"
                      }
                    ]
                  }
                ]
              }
            ]
          },
          {
            "name": "deltaProof",
            "type": "bytes",
            "internalType": "bytes"
          },
          {
            "name": "aggregationProof",
            "type": "bytes",
            "internalType": "bytes"
          }
        ]
      },
      {
        "name": "skipRiscZeroProofVerification",
        "type": "bool",
        "internalType": "bool"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "transferOwnership",
    "inputs": [
      {
        "name": "newOwner",
        "type": "address",
        "internalType": "address"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "event",
    "name": "ActionExecuted",
    "inputs": [
      {
        "name": "actionTreeRoot",
        "type": "bytes32",
        "indexed": false,
        "internalType": "bytes32"
      },
      {
        "name": "actionTagCount",
        "type": "uint256",
        "indexed": false,
        "internalType": "uint256"
      }
    ],
    "anonymous": false
  },
  {
    "type": "event",
    "name": "ApplicationPayload",
    "inputs": [
      {
        "name": "tag",
        "type": "bytes32",
        "indexed": true,
        "internalType": "bytes32"
      },
      {
        "name": "index",
        "type": "uint256",
        "indexed": false,
        "internalType": "uint256"
      },
      {
        "name": "blob",
        "type": "bytes",
        "indexed": false,
        "internalType": "bytes"
      }
    ],
    "anonymous": false
  },
  {
    "type": "event",
    "name": "CommitmentTreeRootAdded",
    "inputs": [
      {
        "name": "root",
        "type": "bytes32",
        "indexed": false,
        "internalType": "bytes32"
      }
    ],
    "anonymous": false
  },
  {
    "type": "event",
    "name": "DiscoveryPayload",
    "inputs": [
      {
        "name": "tag",
        "type": "bytes32",
        "indexed": true,
        "internalType": "bytes32"
      },
      {
        "name": "index",
        "type": "uint256",
        "indexed": false,
        "internalType": "uint256"
      },
      {
        "name": "blob",
        "type": "bytes",
        "indexed": false,
        "internalType": "bytes"
      }
    ],
    "anonymous": false
  },
  {
    "type": "event",
    "name": "ExternalPayload",
    "inputs": [
      {
        "name": "tag",
        "type": "bytes32",
        "indexed": true,
        "internalType": "bytes32"
      },
      {
        "name": "index",
        "type": "uint256",
        "indexed": false,
        "internalType": "uint256"
      },
      {
        "name": "blob",
        "type": "bytes",
        "indexed": false,
        "internalType": "bytes"
      }
    ],
    "anonymous": false
  },
  {
    "type": "event",
    "name": "ForwarderCallExecuted",
    "inputs": [
      {
        "name": "untrustedForwarder",
        "type": "address",
        "indexed": true,
        "internalType": "address"
      },
      {
        "name": "input",
        "type": "bytes",
        "indexed": false,
        "internalType": "bytes"
      },
      {
        "name": "output",
        "type": "bytes",
        "indexed": false,
        "internalType": "bytes"
      }
    ],
    "anonymous": false
  },
  {
    "type": "event",
    "name": "OwnershipTransferred",
    "inputs": [
      {
        "name": "previousOwner",
        "type": "address",
        "indexed": true,
        "internalType": "address"
      },
      {
        "name": "newOwner",
        "type": "address",
        "indexed": true,
        "internalType": "address"
      }
    ],
    "anonymous": false
  },
  {
    "type": "event",
    "name": "Paused",
    "inputs": [
      {
        "name": "account",
        "type": "address",
        "indexed": false,
        "internalType": "address"
      }
    ],
    "anonymous": false
  },
  {
    "type": "event",
    "name": "ResourcePayload",
    "inputs": [
      {
        "name": "tag",
        "type": "bytes32",
        "indexed": true,
        "internalType": "bytes32"
      },
      {
        "name": "index",
        "type": "uint256",
        "indexed": false,
        "internalType": "uint256"
      },
      {
        "name": "blob",
        "type": "bytes",
        "indexed": false,
        "internalType": "bytes"
      }
    ],
    "anonymous": false
  },
  {
    "type": "event",
    "name": "TransactionExecuted",
    "inputs": [
      {
        "name": "tags",
        "type": "bytes32[]",
        "indexed": false,
        "internalType": "bytes32[]"
      },
      {
        "name": "logicRefs",
        "type": "bytes32[]",
        "indexed": false,
        "internalType": "bytes32[]"
      }
    ],
    "anonymous": false
  },
  {
    "type": "event",
    "name": "Unpaused",
    "inputs": [
      {
        "name": "account",
        "type": "address",
        "indexed": false,
        "internalType": "address"
      }
    ],
    "anonymous": false
  },
  {
    "type": "error",
    "name": "DeltaMismatch",
    "inputs": [
      {
        "name": "expected",
        "type": "address",
        "internalType": "address"
      },
      {
        "name": "actual",
        "type": "address",
        "internalType": "address"
      }
    ]
  },
  {
    "type": "error",
    "name": "ECDSAInvalidSignature",
    "inputs": []
  },
  {
    "type": "error",
    "name": "ECDSAInvalidSignatureLength",
    "inputs": [
      {
        "name": "length",
        "type": "uint256",
        "internalType": "uint256"
      }
    ]
  },
  {
    "type": "error",
    "name": "ECDSAInvalidSignatureS",
    "inputs": [
      {
        "name": "s",
        "type": "bytes32",
        "internalType": "bytes32"
      }
    ]
  },
  {
    "type": "error",
    "name": "EnforcedPause",
    "inputs": []
  },
  {
    "type": "error",
    "name": "ExpectedPause",
    "inputs": []
  },
  {
    "type": "error",
    "name": "ForwarderCallOutputMismatch",
    "inputs": [
      {
        "name": "expected",
        "type": "bytes",
        "internalType": "bytes"
      },
      {
        "name": "actual",
        "type": "bytes",
        "internalType": "bytes"
      }
    ]
  },
  {
    "type": "error",
    "name": "LogicRefMismatch",
    "inputs": [
      {
        "name": "expected",
        "type": "bytes32",
        "internalType": "bytes32"
      },
      {
        "name": "actual",
        "type": "bytes32",
        "internalType": "bytes32"
      }
    ]
  },
  {
    "type": "error",
    "name": "NonExistingRoot",
    "inputs": [
      {
        "name": "root",
        "type": "bytes32",
        "internalType": "bytes32"
      }
    ]
  },
  {
    "type": "error",
    "name": "OwnableInvalidOwner",
    "inputs": [
      {
        "name": "owner",
        "type": "address",
        "internalType": "address"
      }
    ]
  },
  {
    "type": "error",
    "name": "OwnableUnauthorizedAccount",
    "inputs": [
      {
        "name": "account",
        "type": "address",
        "internalType": "address"
      }
    ]
  },
  {
    "type": "error",
    "name": "PointNotOnCurve",
    "inputs": [
      {
        "name": "point",
        "type": "tuple",
        "internalType": "struct Delta.Point",
        "components": [
          {
            "name": "x",
            "type": "uint256",
            "internalType": "uint256"
          },
          {
            "name": "y",
            "type": "uint256",
            "internalType": "uint256"
          }
        ]
      }
    ]
  },
  {
    "type": "error",
    "name": "PreExistingNullifier",
    "inputs": [
      {
        "name": "nullifier",
        "type": "bytes32",
        "internalType": "bytes32"
      }
    ]
  },
  {
    "type": "error",
    "name": "PreExistingRoot",
    "inputs": [
      {
        "name": "root",
        "type": "bytes32",
        "internalType": "bytes32"
      }
    ]
  },
  {
    "type": "error",
    "name": "ReentrancyGuardReentrantCall",
    "inputs": []
  },
  {
    "type": "error",
    "name": "RiscZeroVerifierSelectorMismatch",
    "inputs": [
      {
        "name": "expected",
        "type": "bytes4",
        "internalType": "bytes4"
      },
      {
        "name": "actual",
        "type": "bytes4",
        "internalType": "bytes4"
      }
    ]
  },
  {
    "type": "error",
    "name": "RiscZeroVerifierStopped",
    "inputs": []
  },
  {
    "type": "error",
    "name": "Simulated",
    "inputs": [
      {
        "name": "gasUsed",
        "type": "uint256",
        "internalType": "uint256"
      }
    ]
  },
  {
    "type": "error",
    "name": "TagCountMismatch",
    "inputs": [
      {
        "name": "expected",
        "type": "uint256",
        "internalType": "uint256"
      },
      {
        "name": "actual",
        "type": "uint256",
        "internalType": "uint256"
      }
    ]
  },
  {
    "type": "error",
    "name": "TagNotFound",
    "inputs": [
      {
        "name": "tag",
        "type": "bytes32",
        "internalType": "bytes32"
      }
    ]
  },
  {
    "type": "error",
    "name": "ZeroNotAllowed",
    "inputs": []
  }
]
```*/
#[allow(
    non_camel_case_types,
    non_snake_case,
    clippy::pub_underscore_fields,
    clippy::style,
    clippy::empty_structs_with_brackets
)]
pub mod ProtocolAdapter {
    use super::*;
    use alloy::sol_types as alloy_sol_types;
    /// The creation / init bytecode of the contract.
    ///
    /// ```text
    ///0x60c08060405234610242576060816152ec803803809161001f8285610312565b8339810103126102425780516001600160a01b038116918282036102425760208101516001600160e01b031981169182820361024257604001516001600160a01b038116908190036102425780156102ff575f80546001600160a01b03198116831782556001600160a01b0316907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e09080a36101006003555f5f5160206152cc5f395f51905f525b61010082106102ab5750505f6001556100de610349565b507f0a2dc548ed950accb40d5d78541f3954c5e182a8ecf19e581a4f2263f61f59d260206040515f5160206152cc5f395f51905f528152a1831561029c5760209260805260a052602460405180948193633cadf44960e01b835260048301525afa90811561024e575f91610259575b50604051635c975abb60e01b815290602090829060049082906001600160a01b03165afa90811561024e575f9161020f575b508015610201575b6101f257604051614ea9908161040382396080518181816101c50152818161095e01528181611672015281816117d20152818161230701528181612d6101528181612e85015281816132e9015261410c015260a05181818161018301528181611ba8015261421c0152f35b630b1d38a360e01b5f5260045ffd5b5060ff5f5460a01c16610187565b90506020813d602011610246575b8161022a60209383610312565b8101031261024257518015158103610242575f61017f565b5f80fd5b3d915061021d565b6040513d5f823e3d90fd5b90506020813d602011610294575b8161027460209383610312565b8101031261024257516001600160a01b038116810361024257602061014d565b3d9150610267565b6367a5a71760e11b5f5260045ffd5b5f6020916003825280848484200155604051838101918083526040820152604081526102d8606082610312565b604051918291518091835e8101838152039060025afa1561024e5760015f519101906100c7565b631e4fbdf760e01b5f525f60045260245ffd5b601f909101601f19168101906001600160401b0382119082101761033557604052565b634e487b7160e01b5f52604160045260245ffd5b5f5160206152cc5f395f51905f525f5260056020525f5160206152ac5f395f51905f52546103fe57600454680100000000000000008110156103355760018101806004558110156103ea575f5160206152cc5f395f51905f527f8a35acfbc15ff81a39ae7d344fd709f28e8600b4aa8c65c6b64bfe7fe36bd19b9091018190556004545f9190915260056020525f5160206152ac5f395f51905f5255600190565b634e487b7160e01b5f52603260045260245ffd5b5f9056fe6080806040526004361015610012575f80fd5b5f3560e01c9081630d8e6e2c146133655750806331ee62421461334757806340f34d421461332a57806359ba92581461330d5780635b666b1e146132bd5780635c975abb1461329957806363a599a414613208578063715018a61461318c57806382d32ad814611d675780638da5cb5b14611d355780639ad91d4c14611cb8578063a06056f714611c98578063bdeb442d14611c41578063c1b0bed714611c15578063c44956d114611bf8578063c879dbe414611bcc578063e33845cf14611b70578063ed3cf91f146103d5578063f2fde38b14610304578063fddd48371461012a5763fe18ab9114610103575f80fd5b34610126575f600319360112610126576020600160ff600254161b604051908152f35b5f80fd5b34610126575f600319360112610126576040517f3cadf4490000000000000000000000000000000000000000000000000000000081527fffffffff000000000000000000000000000000000000000000000000000000007f000000000000000000000000000000000000000000000000000000000000000016600482015260208160248173ffffffffffffffffffffffffffffffffffffffff7f0000000000000000000000000000000000000000000000000000000000000000165afa9081156102a9575f916102b4575b50602073ffffffffffffffffffffffffffffffffffffffff916004604051809481937f5c975abb000000000000000000000000000000000000000000000000000000008352165afa9081156102a9575f9161026e575b508015610260575b6020906040519015158152f35b505f5460a01c60ff16610253565b90506020813d6020116102a1575b8161028960209383613448565b8101031261012657518015158103610126578161024b565b3d915061027c565b6040513d5f823e3d90fd5b90506020813d6020116102fc575b816102cf60209383613448565b81010312610126575173ffffffffffffffffffffffffffffffffffffffff811681036101265760206101f5565b3d91506102c2565b346101265760206003193601126101265760043573ffffffffffffffffffffffffffffffffffffffff81168091036101265761033e61346b565b80156103a95773ffffffffffffffffffffffffffffffffffffffff5f54827fffffffffffffffffffffffff00000000000000000000000000000000000000008216175f55167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e05f80a3005b7f1e4fbdf7000000000000000000000000000000000000000000000000000000005f525f60045260245ffd5b346101265760206003193601126101265767ffffffffffffffff6004351161012657606060031960043536030112610126577f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005c611b485760017f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005d6104596134b7565b61046161368a565b505f6104716004803501806134ed565b5f91505b808210611ab957826104916044600435016004356004016135c1565b9050151561049e826136f9565b916104a8816136f9565b916104b1613672565b506040516104be816133aa565b5f80825260208201528115611ab2578260011c925b601f196104f86104e2866136e1565b956104f06040519788613448565b8087526136e1565b015f5b818110611a575750508215611a4f57935b601f1961053161051b876136e1565b966105296040519889613448565b8088526136e1565b015f5b818110611a385750506040519561054a8761342b565b865260208601525f604086015260608501525f60808501525f60a085015260c084015260e083015261010082015261058c6004356004016004356004016134ed565b90505f5b818110610c1a5782608081015161061b575b6105e5816105f360207f10dd528db2c49add6545679b976df90d24c035d6a75b17f41b700e8c18ca53649451920151604051938493604085526040850190613612565b908382036020850152613612565b0390a15f7f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005d005b61067161067a6106356024600435016004356004016135c1565b919061064b6044600435016004356004016135c1565b94909361066b60608801519388516020815160051b910120923691613950565b90614d19565b90939193614d53565b60208151910151905f5260205273ffffffffffffffffffffffffffffffffffffffff8060405f2016911690808203610bec57505060c0830151610752575b50506040810151906106c982614ca2565b15610726576105e5907f0a2dc548ed950accb40d5d78541f3954c5e182a8ecf19e581a4f2263f61f59d260207f10dd528db2c49add6545679b976df90d24c035d6a75b17f41b700e8c18ca536494604051908152a19150506105a2565b507fdb788c2b000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b81600411610126576107867fffffffff000000000000000000000000000000000000000000000000000000008235166141f8565b602083015160e084015161010085015190604051926107a48461340f565b835260208301908082526040840192835251926020936040516107c78682613448565b5f8152926040516107d88782613448565b5f8152945f915b87848410610a5c575050505061081d63ffffffff821662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b938160011b9180830460021490151715610a2f5760248661086863ffffffff6028951662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b9451947fffffffff00000000000000000000000000000000000000000000000000000000826040519882828b019b60e01b168b52805191829101868b015e8801917f919e13001cd3319be5a5a7cb189203be083674acb3fff23d05aae9c3ed86314d8584015260e01b1693846044830152805192839101604883015e010190602482015201848251919201905f5b86828210610a1b575050505090610918815f949303601f198101835282613448565b604051918291518091835e8101838152039060025afa156102a9575f519160a084015115610947575b506106b8565b73ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016803b15610126575f926109c992604051958694859384937fab750e75000000000000000000000000000000000000000000000000000000008552606060048601526064850191613844565b907f213b3f40d7c113c1a012072fcd791fa44bf5166a2300121630bd3228e2b008276024840152604483015203915afa80156102a957610a0b575b8080610941565b5f610a1591613448565b81610a04565b8351855293840193909201916001016108f6565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52601160045260245ffd5b9091929695610aaf908280610a7b610a758c885161377b565b51614278565b6040519584879551918291018487015e8401908282015f8152815193849201905e01015f815203601f198101835282613448565b9482518760011b9088820460021489151715610a2f57610ad282610ad89261377b565b516142d6565b84519060018301809311610a2f5760019360048c8193610aff610ad28398610be39861377b565b7fffffffff000000000000000000000000000000000000000000000000000000008380610b5863ffffffff865160021c1662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b610b8e63ffffffff865160021c1662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b95846040519d8b8f82819e519384930191015e8b019260e01b1683830152805192839101602483015e01019260e01b1684830152805192839101600883015e01015f838201520301601f198101835282613448565b960191906107df565b7fe6d44b4c000000000000000000000000000000000000000000000000000000005f5260045260245260445ffd5b610c3281610c2c6004803501806134ed565b90613541565b610c3f60208201826134ed565b80915060011b81810460021482151715610a2f57610c5c906136f9565b905f5b8181106119e1575050600160ff82516fffffffffffffffffffffffffffffffff811160071b67ffffffffffffffff82821c1160061b1763ffffffff82821c1160051b1761ffff82821c1160041b178282821c1160031b17600f82821c1160021b177d01010202020203030303030303030000000000000000000000000000000082821c1a179083821b1001161b610cf5816136f9565b915f5b8281106119865750505b600181116119075750610d149061376e565b5190610d2360208201826134ed565b90505f5b818110610d73575050604060019392610d61837f1cc9a0755dd734c1ebfe98b68ece200037e363eb366d0dee04e420e2f23cc010946134ed565b8351928352602083015250a101610590565b610d8a81610d8460208601866134ed565b90613581565b96610d9361368a565b5060208801906060890135805f52600560205260405f2054156118dc575060c081015186901561176457610e04610e0f93610def60e0850151608086015160011c90610ddf368561379c565b610de9838361377b565b5261377b565b505b610dfb88806134ed565b909135916138d5565b60408b013590613a95565b96610e28610e1d85806134ed565b6080840135916138d5565b60a0820135610e3561368a565b5080602083013503611730575060808136031261012657604051610e58816133f3565b8135815260208201356020820152604082013567ffffffffffffffff8111610126578201906080823603126101265760405191610e94836133f3565b803567ffffffffffffffff811161012657610eb290369083016139a1565b8352602081013567ffffffffffffffff811161012657610ed590369083016139a1565b6020840152604081013567ffffffffffffffff811161012657610efb90369083016139a1565b604084015260608101359067ffffffffffffffff821161012657610f21913691016139a1565b6060830152604081019182526060830190813567ffffffffffffffff811161012657610f509036908601613986565b6060820152610f5d61372a565b5051915160405192610f6e846133f3565b83525f602084015260408301899052606083015260c08b0151156116015750610fa7906101008b015160808c015191610de9838361377b565b505b610fc3610fb96040830183613888565b60408101906134ed565b90505f5b818110611416575050885160808a0190610fe583359183519061377b565b5261100860208b015191805190610ffb82613a68565b905260208401359261377b565b5260ff6002541660015461101b81613a68565b600155908235915f5b828110611370575050600154600160ff600254161b1461132f575b5060408a015261105b6110556040830183613888565b806134ed565b5f5b8181106112cf575050506110816110776040830183613888565b60208101906134ed565b5f5b81811061126f5750505061109d610fb96040830183613888565b5f5b8181106111fd575050506110c36110b96040830183613888565b60608101906134ed565b90915f5b8281106111815750505050606088018051604051926110e5846133aa565b60c0810135845260e060208501910135815260405193611104856133aa565b5f85525f602086015261111a8151835190614563565b15611149579161113b916001969594936020835193015190519151926145c5565b602084015282525201610d27565b604491604051917fb8a0e8a1000000000000000000000000000000000000000000000000000000008352516004830152516024820152fd5b61118c818486613541565b359060028210156101265760018092146111a7575b016110c7565b6111f57fa494dac4b7184843583f972e06783e2c3bb47f4f0137b8df52a860df07219f8c6111e36111d984888a613541565b60208101906135c1565b6040518735949092839290878461454c565b0390a26111a1565b611208818385613541565b35906002821015610126576001809214611223575b0161109f565b6112677f9c61b290f631097f56273cf4daf40df1ff9ccc33f101d464837da1f5ae18bd596112556111d9848789613541565b6040518935949092839290878461454c565b0390a261121d565b61127a818385613541565b35906002821015610126576001809214611295575b01611083565b6112c77f48243873b4752ddcb45e0d7b11c4c266583e5e099a0b798fdd9c1af7d49324f36112556111d9848789613541565b0390a261128f565b6112da818385613541565b359060028210156101265760018092146112f5575b0161105d565b6113277f3a134d01c07803003c63301717ddc4612e6c47ae408eeea3222cded532d02ae66112556111d9848789613541565b0390a26112ef565b9061136a9161133d82614a2a565b60035f527fc2575a0e9e593c00f959f8c92f12db2869c3395a3b0502d05e2516446f71f85b015490614829565b8a61103f565b90926001908185166113de577f405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace830181905560035f527fc2575a0e9e593c00f959f8c92f12db2869c3395a3b0502d05e2516446f71f85b8301546113d391614829565b935b811c9101611024565b60025f527f405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace8301546114109190614829565b936113d5565b61142d6111d982610c2c610fb96040880188613888565b81016060828203126101265781359173ffffffffffffffffffffffffffffffffffffffff831680930361012657602081013567ffffffffffffffff8111610126578261147a918301613986565b91604082013567ffffffffffffffff8111610126576114999201613986565b90604051917f33a8920300000000000000000000000000000000000000000000000000000000835260208701356004840152604060248401525f83806114e260448201866149e0565b038183885af19283156102a9575f93611585575b5082516020840120815160208301200361154a575060019392917fcddb327adb31fe5437df2a8c68301bb13a6baae432a804838caaf682506aadf19161154160405192839283614a05565b0390a201610fc7565b90506115816040519283927fc504fada00000000000000000000000000000000000000000000000000000000845260048401614a05565b0390fd5b9092503d805f833e6115978183613448565b8101906020818303126101265780519067ffffffffffffffff8211610126570181601f82011215610126578051906115ce82613934565b926115dc6040519485613448565b8284526020838301011161012657815f9260208093018386015e83010152918f6114f6565b61160b81846135c1565b600411610126577fffffffff0000000000000000000000000000000000000000000000000000000061163e9135166141f8565b60a08b015115611650575b5050610fa9565b6116a19060205f8161169973ffffffffffffffffffffffffffffffffffffffff7f00000000000000000000000000000000000000000000000000000000000000001694886135c1565b9590966142d6565b604051918183925191829101835e8101838152039060025afa156102a9575f5190803b156101265761170b935f93604051958694859384937fab750e7500000000000000000000000000000000000000000000000000000000855260208b01359160048601613864565b03915afa80156102a957611720575b80611649565b5f61172a91613448565b8961171a565b602092507f18f639d8000000000000000000000000000000000000000000000000000000005f52600452013560245260445ffd5b5061176f89806135c1565b600411610126577fffffffff000000000000000000000000000000000000000000000000000000006117a29135166141f8565b8560a0820151156117ba575b610e04610e0f93610df1565b5073ffffffffffffffffffffffffffffffffffffffff7f0000000000000000000000000000000000000000000000000000000000000000166117fc8a806135c1565b60205f8161181261180d368a61379c565b614278565b604051918183925191829101835e8101838152039060025afa156102a9575f5192803b15610126575f9261187e92604051958694859384937fab750e75000000000000000000000000000000000000000000000000000000008552606060048601526064850191613844565b907f919e13001cd3319be5a5a7cb189203be083674acb3fff23d05aae9c3ed86314d6024840152604483015203915afa80156102a957610e0f938892610e04926118cc575b509350506117ae565b5f6118d691613448565b8c6118c3565b7ff9849ea3000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b60011c5f5b8181106119195750610d02565b8060011b907f7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff81168103610a2f57611951828561377b565b519160018101809111610a2f5760019261196e611975928761377b565b5190614829565b61197f828661377b565b520161190c565b600190825181105f146119b05761199d818461377b565b516119a8828761377b565b525b01610cf8565b7fcc1d2f838445db7aec431df9ee8a871f40e7aa5e064fc056633ef8c60fab7b066119db828761377b565b526119aa565b6119f281610d8460208701876134ed565b908060011b81810460021482151715610a2f576020830135611a14828761377b565b5260018101809111610a2f57611a3160806001940135918661377b565b5201610c5f565b602090611a4361372a565b82828a01015201610534565b505f9361050c565b602090604051611a66816133f3565b604051611a728161340f565b5f81525f848201525f60408201528152604051611a8e816133aa565b5f81525f84820152838201525f60408201525f6060820152828289010152016104fb565b5f926104d3565b9091611acd83610c2c6004803501806134ed565b90611ae7611ade60208401846134ed565b938091506134ed565b9280915060011b9080820460021490151715610a2f57808303611b195750600191611b119161378f565b920190610475565b827fd3bee78d000000000000000000000000000000000000000000000000000000005f5260045260245260445ffd5b7f3ee5aeb5000000000000000000000000000000000000000000000000000000005f5260045ffd5b34610126575f6003193601126101265760206040517fffffffff000000000000000000000000000000000000000000000000000000007f0000000000000000000000000000000000000000000000000000000000000000168152f35b34610126576020600319360112610126576004355f526005602052602060405f20541515604051908152f35b34610126575f600319360112610126576020600154604051908152f35b34610126576020600319360112610126576004355f526007602052602060405f20541515604051908152f35b34610126575f600319360112610126576004547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8101908111610a2f57611c89602091613645565b90549060031b1c604051908152f35b34610126575f60031936011261012657602060ff60025416604051908152f35b3461012657602060031936011261012657600435600654811015611d085760065f527ff652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f0154604051908152602090f35b7f4e487b71000000000000000000000000000000000000000000000000000000005f52603260045260245ffd5b34610126575f60031936011261012657602073ffffffffffffffffffffffffffffffffffffffff5f5416604051908152f35b346101265760406003193601126101265767ffffffffffffffff600435116101265760606003196004353603011261012657602435801515809103610126575a907f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005c611b485760017f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005d611dfa6134b7565b611e0261368a565b505f90611e136004803501806134ed565b5f91505b808210613135575050611e346044600435016004356004016135c1565b9050151591611e42816136f9565b92611e4c826136f9565b92611e55613672565b50604051611e62816133aa565b5f8082526020820152821561312e578360011c935b601f19611e8661051b876136e1565b015f5b8181106130d357505083156130cb57945b601f19611ebf611ea9886136e1565b97611eb7604051998a613448565b8089526136e1565b015f5b8181106130b457505060405196611ed88861342b565b875260208701525f604087015260608601525f608086015260a085015260c084015260e083015261010082015290611f1a6004356004016004356004016134ed565b90505f5b8181106124445750506080820151611fcf575b7f10dd528db2c49add6545679b976df90d24c035d6a75b17f41b700e8c18ca53646105e583611f776020611fa49651920151604051938493604085526040850190613612565b0390a15f7f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005d5a9061339d565b7f6f149831000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b61067161201f611fe96024600435016004356004016135c1565b9190611fff6044600435016004356004016135c1565b94909361066b60608901519389516020815160051b910120923691613950565b60208151910151905f5260205273ffffffffffffffffffffffffffffffffffffffff8060405f2016911690808203610bec57505060c08401516120fb575b505060408201519161206e83614ca2565b156120cf576105e57f10dd528db2c49add6545679b976df90d24c035d6a75b17f41b700e8c18ca5364917f0a2dc548ed950accb40d5d78541f3954c5e182a8ecf19e581a4f2263f61f59d26020611fa496604051908152a193505050611f31565b827fdb788c2b000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b816004116101265761212f7fffffffff000000000000000000000000000000000000000000000000000000008235166141f8565b602084015160e0850151610100860151906040519261214d8461340f565b835260208301908082526040840192835251926020936040516121708682613448565b5f8152926040516121818782613448565b5f8152945f915b878484106123d857505050506121c663ffffffff821662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b938160011b9180830460021490151715610a2f5760248661221163ffffffff6028951662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b9451947fffffffff00000000000000000000000000000000000000000000000000000000826040519882828b019b60e01b168b52805191829101868b015e8801917f919e13001cd3319be5a5a7cb189203be083674acb3fff23d05aae9c3ed86314d8584015260e01b1693846044830152805192839101604883015e010190602482015201848251919201905f5b868282106123c45750505050906122c1815f949303601f198101835282613448565b604051918291518091835e8101838152039060025afa156102a9575f519160a0850151156122f0575b5061205d565b73ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016803b15610126575f9261237292604051958694859384937fab750e75000000000000000000000000000000000000000000000000000000008552606060048601526064850191613844565b907f213b3f40d7c113c1a012072fcd791fa44bf5166a2300121630bd3228e2b008276024840152604483015203915afa80156102a9576123b4575b80806122ea565b5f6123be91613448565b826123ad565b83518552938401939092019160010161229f565b90919296956123f1908280610a7b610a758c885161377b565b9482518760011b9088820460021489151715610a2f57610ad2826124149261377b565b84519060018301809311610a2f5760019360048c8193610aff610ad2839861243b9861377b565b96019190612188565b61245681610c2c6004803501806134ed565b61246360208201826134ed565b80915060011b81810460021482151715610a2f57612480906136f9565b905f5b81811061305d575050600160ff82516fffffffffffffffffffffffffffffffff811160071b67ffffffffffffffff82821c1160061b1763ffffffff82821c1160051b1761ffff82821c1160041b178282821c1160031b17600f82821c1160021b177d01010202020203030303030303030000000000000000000000000000000082821c1a179083821b1001161b612519816136f9565b915f5b8281106130025750505b60018111612f8a57506125389061376e565b519061254760208201826134ed565b90505f5b818110612597575050604060019392612585837f1cc9a0755dd734c1ebfe98b68ece200037e363eb366d0dee04e420e2f23cc010946134ed565b8351928352602083015250a101611f1e565b6125a881610d8460208601866134ed565b976125b161368a565b50602089019060608a0135805f52600560205260405f2054156118dc575060c0810151869015612e17576125fd61260893610def60e0850151608086015160011c90610ddf368561379c565b60408c013590613a95565b97612616610e1d85806134ed565b60a082013561262361368a565b5080602083013503611730575060808136031261012657604051612646816133f3565b8135815260208201356020820152604082013567ffffffffffffffff8111610126578201906080823603126101265760405191612682836133f3565b803567ffffffffffffffff8111610126576126a090369083016139a1565b8352602081013567ffffffffffffffff8111610126576126c390369083016139a1565b6020840152604081013567ffffffffffffffff8111610126576126e990369083016139a1565b604084015260608101359067ffffffffffffffff82116101265761270f913691016139a1565b6060830152604081019182526060830190813567ffffffffffffffff81116101265761273e9036908601613986565b606082015261274b61372a565b505191516040519261275c846133f3565b83525f602084015260408301899052606083015260c08c015115612cf05750612795906101008c015160808d015191610de9838361377b565b505b6127a7610fb96040830183613888565b90505f5b818110612b40575050895160808b01906127c983359183519061377b565b526127df60208c015191805190610ffb82613a68565b5260ff600254166001546127f281613a68565b600155908235915f5b828110612a9a575050600154600160ff600254161b14612a86575b5060408b015261282c6110556040830183613888565b5f5b818110612a26575050506128486110776040830183613888565b5f5b8181106129c657505050612864610fb96040830183613888565b5f5b818110612966575050506128806110b96040830183613888565b90915f5b8281106129065750505050606089018051604051926128a2846133aa565b60c0810135845260e0602085019101358152604051936128c1856133aa565b5f85525f60208601526128d78151835190614563565b1561114957916128f8916001969594936020835193015190519151926145c5565b60208401528252520161254b565b612911818486613541565b3590600282101561012657600180921461292c575b01612884565b61295e7fa494dac4b7184843583f972e06783e2c3bb47f4f0137b8df52a860df07219f8c6111e36111d984888a613541565b0390a2612926565b612971818385613541565b3590600282101561012657600180921461298c575b01612866565b6129be7f9c61b290f631097f56273cf4daf40df1ff9ccc33f101d464837da1f5ae18bd596112556111d9848789613541565b0390a2612986565b6129d1818385613541565b359060028210156101265760018092146129ec575b0161284a565b612a1e7f48243873b4752ddcb45e0d7b11c4c266583e5e099a0b798fdd9c1af7d49324f36112556111d9848789613541565b0390a26129e6565b612a31818385613541565b35906002821015610126576001809214612a4c575b0161282e565b612a7e7f3a134d01c07803003c63301717ddc4612e6c47ae408eeea3222cded532d02ae66112556111d9848789613541565b0390a2612a46565b90612a949161133d82614a2a565b8b612816565b9092600190818516612b08577f405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace830181905560035f527fc2575a0e9e593c00f959f8c92f12db2869c3395a3b0502d05e2516446f71f85b830154612afd91614829565b935b811c91016127fb565b60025f527f405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace830154612b3a9190614829565b93612aff565b612b576111d982610c2c610fb96040880188613888565b81016060828203126101265781359173ffffffffffffffffffffffffffffffffffffffff831680930361012657602081013567ffffffffffffffff81116101265782612ba4918301613986565b91604082013567ffffffffffffffff811161012657612bc39201613986565b90604051917f33a8920300000000000000000000000000000000000000000000000000000000835260208701356004840152604060248401525f8380612c0c60448201866149e0565b038183885af19283156102a9575f93612c74575b5082516020840120815160208301200361154a575060019392917fcddb327adb31fe5437df2a8c68301bb13a6baae432a804838caaf682506aadf191612c6b60405192839283614a05565b0390a2016127ab565b9092503d805f833e612c868183613448565b8101906020818303126101265780519067ffffffffffffffff8211610126570181601f8201121561012657805190612cbd82613934565b92612ccb6040519485613448565b8284526020838301011161012657815f9260208093018386015e83010152915f612c20565b612cfa81846135c1565b600411610126577fffffffff00000000000000000000000000000000000000000000000000000000612d2d9135166141f8565b60a08c015115612d3f575b5050612797565b612d889060205f8161169973ffffffffffffffffffffffffffffffffffffffff7f00000000000000000000000000000000000000000000000000000000000000001694886135c1565b604051918183925191829101835e8101838152039060025afa156102a9575f5190803b1561012657612df2935f93604051958694859384937fab750e7500000000000000000000000000000000000000000000000000000000855260208b01359160048601613864565b03915afa80156102a957612e07575b80612d38565b5f612e1191613448565b8a612e01565b50612e228a806135c1565b600411610126577fffffffff00000000000000000000000000000000000000000000000000000000612e559135166141f8565b8560a082015115612e6d575b6125fd61260893610df1565b5073ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016612eaf8b806135c1565b60205f81612ec061180d368a61379c565b604051918183925191829101835e8101838152039060025afa156102a9575f5192803b15610126575f92612f2c92604051958694859384937fab750e75000000000000000000000000000000000000000000000000000000008552606060048601526064850191613844565b907f919e13001cd3319be5a5a7cb189203be083674acb3fff23d05aae9c3ed86314d6024840152604483015203915afa80156102a9576126089388926125fd92612f7a575b50935050612e61565b5f612f8491613448565b8d612f71565b60011c5f5b818110612f9c5750612526565b8060011b907f7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff81168103610a2f57612fd4828561377b565b519160018101809111610a2f5760019261196e612ff1928761377b565b612ffb828661377b565b5201612f8f565b600190825181105f1461302c57613019818461377b565b51613024828761377b565b525b0161251c565b7fcc1d2f838445db7aec431df9ee8a871f40e7aa5e064fc056633ef8c60fab7b06613057828761377b565b52613026565b61306e81610d8460208701876134ed565b908060011b81810460021482151715610a2f576020830135613090828761377b565b5260018101809111610a2f576130ad60806001940135918661377b565b5201612483565b6020906130bf61372a565b82828b01015201611ec2565b505f94611e9a565b6020906040516130e2816133f3565b6040516130ee8161340f565b5f81525f848201525f6040820152815260405161310a816133aa565b5f81525f84820152838201525f60408201525f606082015282828a01015201611e89565b5f93611e77565b909261314984610c2c6004803501806134ed565b9061315a611ade60208401846134ed565b9280915060011b9080820460021490151715610a2f57808303611b1957506001916131849161378f565b930190611e17565b34610126575f600319360112610126576131a461346b565b5f73ffffffffffffffffffffffffffffffffffffffff81547fffffffffffffffffffffffff000000000000000000000000000000000000000081168355167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e08280a3005b34610126575f6003193601126101265761322061346b565b6132286134b7565b6132306134b7565b740100000000000000000000000000000000000000007fffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff5f5416175f557f62e78cea01bee320cd4e420270b5ea74000d11b0c9f74754ebdbfc544b05a2586020604051338152a1005b34610126575f60031936011261012657602060ff5f5460a01c166040519015158152f35b34610126575f60031936011261012657602060405173ffffffffffffffffffffffffffffffffffffffff7f0000000000000000000000000000000000000000000000000000000000000000168152f35b34610126575f600319360112610126576020600454604051908152f35b34610126575f600319360112610126576020600654604051908152f35b34610126576020600319360112610126576020611c89600435613645565b34610126575f60031936011261012657807f312e312e3000000000000000000000000000000000000000000000000000000060209252f35b91908203918211610a2f57565b6040810190811067ffffffffffffffff8211176133c657604052565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52604160045260245ffd5b6080810190811067ffffffffffffffff8211176133c657604052565b6060810190811067ffffffffffffffff8211176133c657604052565b610120810190811067ffffffffffffffff8211176133c657604052565b90601f601f19910116810190811067ffffffffffffffff8211176133c657604052565b73ffffffffffffffffffffffffffffffffffffffff5f5416330361348b57565b7f118cdaa7000000000000000000000000000000000000000000000000000000005f523360045260245ffd5b60ff5f5460a01c166134c557565b7fd93c0665000000000000000000000000000000000000000000000000000000005f5260045ffd5b9035907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe181360301821215610126570180359067ffffffffffffffff821161012657602001918160051b3603831361012657565b9190811015611d085760051b810135907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc181360301821215610126570190565b9190811015611d085760051b810135907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0181360301821215610126570190565b9035907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe181360301821215610126570180359067ffffffffffffffff82116101265760200191813603831361012657565b90602080835192838152019201905f5b81811061362f5750505090565b8251845260209384019390920191600101613622565b600454811015611d085760045f5260205f2001905f90565b8054821015611d08575f5260205f2001905f90565b6040519061367f826133aa565b5f6020838281520152565b604051906136978261342b565b6060610100838281528260208201525f60408201526040516136b8816133aa565b5f81525f6020820152838201525f60808201525f60a08201525f60c08201528260e08201520152565b67ffffffffffffffff81116133c65760051b60200190565b90613703826136e1565b6137106040519182613448565b828152601f1961372082946136e1565b0190602036910137565b60405190613737826133f3565b815f81525f60208201525f6040820152606060405191613756836133f3565b81835281602084015281604084015281808401520152565b805115611d085760200190565b8051821015611d085760209160051b010190565b91908201809211610a2f57565b809291039160e0831261012657604051906137b6826133f3565b819360608112610126577fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa060409182516137ef8161340f565b84358152602085013560208201528385013584820152855201126101265760c060609160405161381e816133aa565b83820135815260808201356020820152602085015260a081013560408501520135910152565b601f8260209493601f1993818652868601375f8582860101520116010190565b9061387e9060409396959496606084526060840191613844565b9460208201520152565b9035907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8181360301821215610126570190565b90821015611d08576138d29160051b810190613888565b90565b909291925f5b81811061390e57847f89211474000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b8461391a8284866138bb565b3514613928576001016138db565b916138d29394506138bb565b67ffffffffffffffff81116133c657601f01601f191660200190565b92919261395c82613934565b9161396a6040519384613448565b829481845281830111610126578281602093845f960137010152565b9080601f83011215610126578160206138d293359101613950565b9080601f83011215610126578135916139b9836136e1565b926139c76040519485613448565b80845260208085019160051b830101918383116101265760208101915b8383106139f357505050505090565b823567ffffffffffffffff8111610126578201906040601f1983880301126101265760405190613a22826133aa565b6020830135600281101561012657825260408301359167ffffffffffffffff831161012657613a5988602080969581960101613986565b838201528152019201916139e4565b7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8114610a2f5760010190565b93929091613aa161368a565b5081945f936020820135908082036141ca57506080823603126101265760405193613acb856133f3565b8235948581528260208201526040840194853567ffffffffffffffff8111610126578501906080823603126101265760405191613b07836133f3565b803567ffffffffffffffff811161012657613b2590369083016139a1565b8352602081013567ffffffffffffffff811161012657613b4890369083016139a1565b6020840152604081013567ffffffffffffffff811161012657613b6e90369083016139a1565b604084015260608101359067ffffffffffffffff821161012657613b94913691016139a1565b6060830152604083019182526060860192833567ffffffffffffffff811161012657613bc39036908901613986565b6060820152613bd061372a565b505191519060405192613be2846133f3565b8352600160208401526040830152606082015260c08301511561409b57613c1a9150610100830151608084015191610de9838361377b565b505b613c29610fb98585613888565b9050865b818110613ed0575050806020613c6692519187613c50608083019485519061377b565b520151815191613c5f83613a68565b905261377b565b52613c7083614cdb565b15613ea457613c826110558383613888565b855b818110613e3557505050613c9b6110778383613888565b855b818110613dc657505050613cb4610fb98383613888565b855b818110613d5357505050613ccd916110b991613888565b839291925b818110613ce0575050505050565b613ceb818386613541565b356002811015613d4f57906001809214613d06575b01613cd2565b837fa494dac4b7184843583f972e06783e2c3bb47f4f0137b8df52a860df07219f8c613d366111d984878a613541565b90613d47604051928392878461454c565b0390a2613d00565b8580fd5b613d5e818385613541565b356002811015613dc257906001809214613d79575b01613cb6565b867f9c61b290f631097f56273cf4daf40df1ff9ccc33f101d464837da1f5ae18bd59613da96111d9848789613541565b90613dba604051928392878461454c565b0390a2613d73565b8780fd5b613dd1818385613541565b356002811015613dc257906001809214613dec575b01613c9d565b867f48243873b4752ddcb45e0d7b11c4c266583e5e099a0b798fdd9c1af7d49324f3613e1c6111d9848789613541565b90613e2d604051928392878461454c565b0390a2613de6565b613e40818385613541565b356002811015613dc257906001809214613e5b575b01613c84565b867f3a134d01c07803003c63301717ddc4612e6c47ae408eeea3222cded532d02ae6613e8b6111d9848789613541565b90613e9c604051928392878461454c565b0390a2613e55565b602484847f39a940c5000000000000000000000000000000000000000000000000000000008252600452fd5b613ee46111d982610c2c610fb98a8a613888565b8101906060818303126140975780359173ffffffffffffffffffffffffffffffffffffffff831680930361409357602082013567ffffffffffffffff811161408f5781613f32918401613986565b9160408101359067ffffffffffffffff821161408057613f53929101613986565b90604051917f33a89203000000000000000000000000000000000000000000000000000000008352876004840152604060248401528b8380613f9860448201866149e0565b038183885af1928315614084578c93614000575b5082516020840120815160208301200361154a575060019392917fcddb327adb31fe5437df2a8c68301bb13a6baae432a804838caaf682506aadf191613ff760405192839283614a05565b0390a201613c2d565b9092503d808d833e6140128183613448565b8101906020818303126140805780519067ffffffffffffffff821161407c570181601f820112156140805780519061404982613934565b926140576040519485613448565b8284526020838301011161407c57818e9260208093018386015e83010152915f613fac565b8d80fd5b8c80fd5b6040513d8e823e3d90fd5b8b80fd5b8a80fd5b8980fd5b6140a582866135c1565b600411610126577fffffffff000000000000000000000000000000000000000000000000000000006140d89135166141f8565b60a0830151156140ea575b5050613c1c565b61413b9060205f8161413373ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016968a6135c1565b9590946142d6565b604051918183925191829101835e8101838152039060025afa156102a9575f5192803b15610126575f9286926141a0604051968795869485947fab750e7500000000000000000000000000000000000000000000000000000000865260048601613864565b03915afa80156102a9576141b5575b806140e3565b6141c29196505f90613448565b5f945f6141af565b7f18f639d8000000000000000000000000000000000000000000000000000000005f5260045260245260445ffd5b7fffffffff00000000000000000000000000000000000000000000000000000000807f00000000000000000000000000000000000000000000000000000000000000001691169080820361424a575050565b7f78a2221c000000000000000000000000000000000000000000000000000000005f5260045260245260445ffd5b80518051916040602083015192015160208201516020815191015191606060408501519401519460405196602088015260408701526060860152608085015260a084015260c083015260e082015260e081526138d261010082613448565b606081015181516020830151909190156145435760406301000000935b015190805190815163ffffffff1661432d9062ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b916143379061486c565b6020820151805163ffffffff166143709062ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b9061437a9061486c565b90604084015192835163ffffffff166143b59062ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b936143bf9061486c565b946060015195865163ffffffff166143f99062ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b966144039061486c565b976040519a8b9a60208c015260e01b7fffffffff000000000000000000000000000000000000000000000000000000001660408b015260448a015260e01b7fffffffff000000000000000000000000000000000000000000000000000000001660648901528051602081920160688a015e87019060e01b7fffffffff0000000000000000000000000000000000000000000000000000000016606882015281516020819301606c83015e016068019060e01b7fffffffff0000000000000000000000000000000000000000000000000000000016600482015281516020819301600883015e016004019060e01b7fffffffff0000000000000000000000000000000000000000000000000000000016600482015281516020819301600883015e01600401600481015f905203600401601f19810182526138d29082613448565b60405f936142f3565b6040906138d2949281528160208201520191613844565b801580156145b5575b80156145ad575b801561459d575b614597576401000003d01960078180938181800909089180091490565b50505f90565b506401000003d01982101561457a565b508115614573565b506401000003d01981101561456c565b90939290915f9080840361480d5750506401000003d0195f9185086145ee57505090505f905f90565b6401000003d01980600181806146558180806146459a81808f800996879281808080808f81818192099987096004099780095f09928009600309089181614638818380088261339d565b81858009089d8e8361339d565b900890099380096008098361339d565b900896096002099391905b84151585816147fc575b50806147f4575b156147965780948060016401000003d01984925b6146d95750505050806146ac5750906401000003d019809281808780098092099509900990565b807f4e487b7100000000000000000000000000000000000000000000000000000000602492526012600452fd5b9297919288156147695788810491809461473c576401000003d0199083096401000003d019036401000003d0198111610a2f576401000003d0199086940893988092818102918183041490151715610a2f576147349161339d565b929083614685565b6024867f4e487b710000000000000000000000000000000000000000000000000000000081526012600452fd5b7f4e487b71000000000000000000000000000000000000000000000000000000005f52601260045260245ffd5b60646040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152600e60248201527f496e76616c6964206e756d6265720000000000000000000000000000000000006044820152fd5b506001614671565b6401000003d019915014155f61466a565b6401000003d01992919561482094614aa7565b93909190614660565b5f906020926040519084820192835260408201526040815261484c606082613448565b604051918291518091835e8101838152039060025afa156102a9575f5190565b8051606092915f915b80831061488157505050565b9091936148c863ffffffff6020614898888761377b565b5101515160021c1662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b9060206148d5878661377b565b5101516148e2878661377b565b515160028110156149b35760046020936149aa937fffffffff000000000000000000000000000000000000000000000000000000008680600199614949879862ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b94846040519b888d995191829101868b015e88019260e01b1683830152805192839101602483015e01019160e01b168382015203017fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe4810184520182613448565b94019190614875565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52602160045260245ffd5b90601f19601f602080948051918291828752018686015e5f8582860101520116010190565b9091614a1c6138d2936040845260408401906149e0565b9160208184039101526149e0565b600254680100000000000000008110156133c657806001614a509201600255600261365d565b7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff829392549160031b92831b921b1916179055565b8054680100000000000000008110156133c657614a509160018201815561365d565b949291851580614c9a575b614c8e57801580614c86575b614c7c57604051608091614ad28383613448565b8236833786156147695786948580928180600180098087529781896001099c602088019d8e5282604089019d8e8c8152516001099160608a019283526040519e8f614b1c906133f3565b5190098d525190099460208b019586525190099860408901998a52519009606087019081528651885114801590614c70575b15614c1257849283808093816040519c85614b6a8f9788613448565b368737518c51614b7a908361339d565b90088452518551614b8b908361339d565b90089860208301998a5281808b8180808089518a5190099360408a019485528185518b5190096060909a01998a525180098851614bc8908361339d565b90088180875185519009600209614bdf908361339d565b90089c51935190519009614bf38c8361339d565b90089009925190519009614c07908361339d565b900894510991929190565b60646040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601e60248201527f557365206a6163446f75626c652066756e6374696f6e20696e737465616400006044820152fd5b50815181511415614b4e565b5092506001919050565b508215614abe565b94509092506001919050565b508115614ab2565b805f52600560205260405f2054155f14614cd657614cc1816004614a85565b600454905f52600560205260405f2055600190565b505f90565b805f52600760205260405f2054155f14614cd657614cfa816006614a85565b600654905f52600760205260405f2055600190565b600411156149b357565b8151919060418303614d4957614d429250602082015190606060408401519301515f1a90614e1a565b9192909190565b50505f9160029190565b614d5c81614d0f565b80614d65575050565b614d6e81614d0f565b60018103614d9e577ff645eedf000000000000000000000000000000000000000000000000000000005f5260045ffd5b614da781614d0f565b60028103614ddb57507ffce698f7000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b600390614de781614d0f565b14614def5750565b7fd78bce0c000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b91907f7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a08411614e9e579160209360809260ff5f9560405194855216868401526040830152606082015282805260015afa156102a9575f5173ffffffffffffffffffffffffffffffffffffffff811615614e9457905f905f90565b505f906001905f90565b5050505f916003919056fcedd375898c00de52e8f13b0b8e32ad9c1577fe333b1d8f9c932ae1bca6dac3cc1d2f838445db7aec431df9ee8a871f40e7aa5e064fc056633ef8c60fab7b06
    /// ```
    #[rustfmt::skip]
    #[allow(clippy::all)]
    pub static BYTECODE: alloy_sol_types::private::Bytes = alloy_sol_types::private::Bytes::from_static(
        b"`\xC0\x80`@R4a\x02BW``\x81aR\xEC\x808\x03\x80\x91a\0\x1F\x82\x85a\x03\x12V[\x839\x81\x01\x03\x12a\x02BW\x80Q`\x01`\x01`\xA0\x1B\x03\x81\x16\x91\x82\x82\x03a\x02BW` \x81\x01Q`\x01`\x01`\xE0\x1B\x03\x19\x81\x16\x91\x82\x82\x03a\x02BW`@\x01Q`\x01`\x01`\xA0\x1B\x03\x81\x16\x90\x81\x90\x03a\x02BW\x80\x15a\x02\xFFW_\x80T`\x01`\x01`\xA0\x1B\x03\x19\x81\x16\x83\x17\x82U`\x01`\x01`\xA0\x1B\x03\x16\x90\x7F\x8B\xE0\x07\x9CS\x16Y\x14\x13D\xCD\x1F\xD0\xA4\xF2\x84\x19I\x7F\x97\"\xA3\xDA\xAF\xE3\xB4\x18okdW\xE0\x90\x80\xA3a\x01\0`\x03U__Q` aR\xCC_9_Q\x90_R[a\x01\0\x82\x10a\x02\xABWPP_`\x01Ua\0\xDEa\x03IV[P\x7F\n-\xC5H\xED\x95\n\xCC\xB4\r]xT\x1F9T\xC5\xE1\x82\xA8\xEC\xF1\x9EX\x1AO\"c\xF6\x1FY\xD2` `@Q_Q` aR\xCC_9_Q\x90_R\x81R\xA1\x83\x15a\x02\x9CW` \x92`\x80R`\xA0R`$`@Q\x80\x94\x81\x93c<\xAD\xF4I`\xE0\x1B\x83R`\x04\x83\x01RZ\xFA\x90\x81\x15a\x02NW_\x91a\x02YW[P`@Qc\\\x97Z\xBB`\xE0\x1B\x81R\x90` \x90\x82\x90`\x04\x90\x82\x90`\x01`\x01`\xA0\x1B\x03\x16Z\xFA\x90\x81\x15a\x02NW_\x91a\x02\x0FW[P\x80\x15a\x02\x01W[a\x01\xF2W`@QaN\xA9\x90\x81a\x04\x03\x829`\x80Q\x81\x81\x81a\x01\xC5\x01R\x81\x81a\t^\x01R\x81\x81a\x16r\x01R\x81\x81a\x17\xD2\x01R\x81\x81a#\x07\x01R\x81\x81a-a\x01R\x81\x81a.\x85\x01R\x81\x81a2\xE9\x01RaA\x0C\x01R`\xA0Q\x81\x81\x81a\x01\x83\x01R\x81\x81a\x1B\xA8\x01RaB\x1C\x01R\xF3[c\x0B\x1D8\xA3`\xE0\x1B_R`\x04_\xFD[P`\xFF_T`\xA0\x1C\x16a\x01\x87V[\x90P` \x81=` \x11a\x02FW[\x81a\x02*` \x93\x83a\x03\x12V[\x81\x01\x03\x12a\x02BWQ\x80\x15\x15\x81\x03a\x02BW_a\x01\x7FV[_\x80\xFD[=\x91Pa\x02\x1DV[`@Q=_\x82>=\x90\xFD[\x90P` \x81=` \x11a\x02\x94W[\x81a\x02t` \x93\x83a\x03\x12V[\x81\x01\x03\x12a\x02BWQ`\x01`\x01`\xA0\x1B\x03\x81\x16\x81\x03a\x02BW` a\x01MV[=\x91Pa\x02gV[cg\xA5\xA7\x17`\xE1\x1B_R`\x04_\xFD[_` \x91`\x03\x82R\x80\x84\x84\x84 \x01U`@Q\x83\x81\x01\x91\x80\x83R`@\x82\x01R`@\x81Ra\x02\xD8``\x82a\x03\x12V[`@Q\x91\x82\x91Q\x80\x91\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02NW`\x01_Q\x91\x01\x90a\0\xC7V[c\x1EO\xBD\xF7`\xE0\x1B_R_`\x04R`$_\xFD[`\x1F\x90\x91\x01`\x1F\x19\x16\x81\x01\x90`\x01`\x01`@\x1B\x03\x82\x11\x90\x82\x10\x17a\x035W`@RV[cNH{q`\xE0\x1B_R`A`\x04R`$_\xFD[_Q` aR\xCC_9_Q\x90_R_R`\x05` R_Q` aR\xAC_9_Q\x90_RTa\x03\xFEW`\x04Th\x01\0\0\0\0\0\0\0\0\x81\x10\x15a\x035W`\x01\x81\x01\x80`\x04U\x81\x10\x15a\x03\xEAW_Q` aR\xCC_9_Q\x90_R\x7F\x8A5\xAC\xFB\xC1_\xF8\x1A9\xAE}4O\xD7\t\xF2\x8E\x86\0\xB4\xAA\x8Ce\xC6\xB6K\xFE\x7F\xE3k\xD1\x9B\x90\x91\x01\x81\x90U`\x04T_\x91\x90\x91R`\x05` R_Q` aR\xAC_9_Q\x90_RU`\x01\x90V[cNH{q`\xE0\x1B_R`2`\x04R`$_\xFD[_\x90V\xFE`\x80\x80`@R`\x046\x10\x15a\0\x12W_\x80\xFD[_5`\xE0\x1C\x90\x81c\r\x8En,\x14a3eWP\x80c1\xEEbB\x14a3GW\x80c@\xF3MB\x14a3*W\x80cY\xBA\x92X\x14a3\rW\x80c[fk\x1E\x14a2\xBDW\x80c\\\x97Z\xBB\x14a2\x99W\x80cc\xA5\x99\xA4\x14a2\x08W\x80cqP\x18\xA6\x14a1\x8CW\x80c\x82\xD3*\xD8\x14a\x1DgW\x80c\x8D\xA5\xCB[\x14a\x1D5W\x80c\x9A\xD9\x1DL\x14a\x1C\xB8W\x80c\xA0`V\xF7\x14a\x1C\x98W\x80c\xBD\xEBD-\x14a\x1CAW\x80c\xC1\xB0\xBE\xD7\x14a\x1C\x15W\x80c\xC4IV\xD1\x14a\x1B\xF8W\x80c\xC8y\xDB\xE4\x14a\x1B\xCCW\x80c\xE38E\xCF\x14a\x1BpW\x80c\xED<\xF9\x1F\x14a\x03\xD5W\x80c\xF2\xFD\xE3\x8B\x14a\x03\x04W\x80c\xFD\xDDH7\x14a\x01*Wc\xFE\x18\xAB\x91\x14a\x01\x03W_\x80\xFD[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\x01`\xFF`\x02T\x16\x1B`@Q\x90\x81R\xF3[_\x80\xFD[4a\x01&W_`\x03\x196\x01\x12a\x01&W`@Q\x7F<\xAD\xF4I\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`\x04\x82\x01R` \x81`$\x81s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16Z\xFA\x90\x81\x15a\x02\xA9W_\x91a\x02\xB4W[P` s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x91`\x04`@Q\x80\x94\x81\x93\x7F\\\x97Z\xBB\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83R\x16Z\xFA\x90\x81\x15a\x02\xA9W_\x91a\x02nW[P\x80\x15a\x02`W[` \x90`@Q\x90\x15\x15\x81R\xF3[P_T`\xA0\x1C`\xFF\x16a\x02SV[\x90P` \x81=` \x11a\x02\xA1W[\x81a\x02\x89` \x93\x83a4HV[\x81\x01\x03\x12a\x01&WQ\x80\x15\x15\x81\x03a\x01&W\x81a\x02KV[=\x91Pa\x02|V[`@Q=_\x82>=\x90\xFD[\x90P` \x81=` \x11a\x02\xFCW[\x81a\x02\xCF` \x93\x83a4HV[\x81\x01\x03\x12a\x01&WQs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x81\x03a\x01&W` a\x01\xF5V[=\x91Pa\x02\xC2V[4a\x01&W` `\x03\x196\x01\x12a\x01&W`\x045s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x80\x91\x03a\x01&Wa\x03>a4kV[\x80\x15a\x03\xA9Ws\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF_T\x82\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82\x16\x17_U\x16\x7F\x8B\xE0\x07\x9CS\x16Y\x14\x13D\xCD\x1F\xD0\xA4\xF2\x84\x19I\x7F\x97\"\xA3\xDA\xAF\xE3\xB4\x18okdW\xE0_\x80\xA3\0[\x7F\x1EO\xBD\xF7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R_`\x04R`$_\xFD[4a\x01&W` `\x03\x196\x01\x12a\x01&Wg\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF`\x045\x11a\x01&W```\x03\x19`\x0456\x03\x01\x12a\x01&W\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0\\a\x1BHW`\x01\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0]a\x04Ya4\xB7V[a\x04aa6\x8AV[P_a\x04q`\x04\x805\x01\x80a4\xEDV[_\x91P[\x80\x82\x10a\x1A\xB9W\x82a\x04\x91`D`\x045\x01`\x045`\x04\x01a5\xC1V[\x90P\x15\x15a\x04\x9E\x82a6\xF9V[\x91a\x04\xA8\x81a6\xF9V[\x91a\x04\xB1a6rV[P`@Qa\x04\xBE\x81a3\xAAV[_\x80\x82R` \x82\x01R\x81\x15a\x1A\xB2W\x82`\x01\x1C\x92[`\x1F\x19a\x04\xF8a\x04\xE2\x86a6\xE1V[\x95a\x04\xF0`@Q\x97\x88a4HV[\x80\x87Ra6\xE1V[\x01_[\x81\x81\x10a\x1AWWPP\x82\x15a\x1AOW\x93[`\x1F\x19a\x051a\x05\x1B\x87a6\xE1V[\x96a\x05)`@Q\x98\x89a4HV[\x80\x88Ra6\xE1V[\x01_[\x81\x81\x10a\x1A8WPP`@Q\x95a\x05J\x87a4+V[\x86R` \x86\x01R_`@\x86\x01R``\x85\x01R_`\x80\x85\x01R_`\xA0\x85\x01R`\xC0\x84\x01R`\xE0\x83\x01Ra\x01\0\x82\x01Ra\x05\x8C`\x045`\x04\x01`\x045`\x04\x01a4\xEDV[\x90P_[\x81\x81\x10a\x0C\x1AW\x82`\x80\x81\x01Qa\x06\x1BW[a\x05\xE5\x81a\x05\xF3` \x7F\x10\xDDR\x8D\xB2\xC4\x9A\xDDeEg\x9B\x97m\xF9\r$\xC05\xD6\xA7[\x17\xF4\x1Bp\x0E\x8C\x18\xCASd\x94Q\x92\x01Q`@Q\x93\x84\x93`@\x85R`@\x85\x01\x90a6\x12V[\x90\x83\x82\x03` \x85\x01Ra6\x12V[\x03\x90\xA1_\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0]\0[a\x06qa\x06za\x065`$`\x045\x01`\x045`\x04\x01a5\xC1V[\x91\x90a\x06K`D`\x045\x01`\x045`\x04\x01a5\xC1V[\x94\x90\x93a\x06k``\x88\x01Q\x93\x88Q` \x81Q`\x05\x1B\x91\x01 \x926\x91a9PV[\x90aM\x19V[\x90\x93\x91\x93aMSV[` \x81Q\x91\x01Q\x90_R` Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x80`@_ \x16\x91\x16\x90\x80\x82\x03a\x0B\xECWPP`\xC0\x83\x01Qa\x07RW[PP`@\x81\x01Q\x90a\x06\xC9\x82aL\xA2V[\x15a\x07&Wa\x05\xE5\x90\x7F\n-\xC5H\xED\x95\n\xCC\xB4\r]xT\x1F9T\xC5\xE1\x82\xA8\xEC\xF1\x9EX\x1AO\"c\xF6\x1FY\xD2` \x7F\x10\xDDR\x8D\xB2\xC4\x9A\xDDeEg\x9B\x97m\xF9\r$\xC05\xD6\xA7[\x17\xF4\x1Bp\x0E\x8C\x18\xCASd\x94`@Q\x90\x81R\xA1\x91PPa\x05\xA2V[P\x7F\xDBx\x8C+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[\x81`\x04\x11a\x01&Wa\x07\x86\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x825\x16aA\xF8V[` \x83\x01Q`\xE0\x84\x01Qa\x01\0\x85\x01Q\x90`@Q\x92a\x07\xA4\x84a4\x0FV[\x83R` \x83\x01\x90\x80\x82R`@\x84\x01\x92\x83RQ\x92` \x93`@Qa\x07\xC7\x86\x82a4HV[_\x81R\x92`@Qa\x07\xD8\x87\x82a4HV[_\x81R\x94_\x91[\x87\x84\x84\x10a\n\\WPPPPa\x08\x1Dc\xFF\xFF\xFF\xFF\x82\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x93\x81`\x01\x1B\x91\x80\x83\x04`\x02\x14\x90\x15\x17\x15a\n/W`$\x86a\x08hc\xFF\xFF\xFF\xFF`(\x95\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x94Q\x94\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82`@Q\x98\x82\x82\x8B\x01\x9B`\xE0\x1B\x16\x8BR\x80Q\x91\x82\x91\x01\x86\x8B\x01^\x88\x01\x91\x7F\x91\x9E\x13\0\x1C\xD31\x9B\xE5\xA5\xA7\xCB\x18\x92\x03\xBE\x086t\xAC\xB3\xFF\xF2=\x05\xAA\xE9\xC3\xED\x861M\x85\x84\x01R`\xE0\x1B\x16\x93\x84`D\x83\x01R\x80Q\x92\x83\x91\x01`H\x83\x01^\x01\x01\x90`$\x82\x01R\x01\x84\x82Q\x91\x92\x01\x90_[\x86\x82\x82\x10a\n\x1BWPPPP\x90a\t\x18\x81_\x94\x93\x03`\x1F\x19\x81\x01\x83R\x82a4HV[`@Q\x91\x82\x91Q\x80\x91\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xA9W_Q\x91`\xA0\x84\x01Q\x15a\tGW[Pa\x06\xB8V[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x80;\x15a\x01&W_\x92a\t\xC9\x92`@Q\x95\x86\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R```\x04\x86\x01R`d\x85\x01\x91a8DV[\x90\x7F!;?@\xD7\xC1\x13\xC1\xA0\x12\x07/\xCDy\x1F\xA4K\xF5\x16j#\0\x12\x160\xBD2(\xE2\xB0\x08'`$\x84\x01R`D\x83\x01R\x03\x91Z\xFA\x80\x15a\x02\xA9Wa\n\x0BW[\x80\x80a\tAV[_a\n\x15\x91a4HV[\x81a\n\x04V[\x83Q\x85R\x93\x84\x01\x93\x90\x92\x01\x91`\x01\x01a\x08\xF6V[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x11`\x04R`$_\xFD[\x90\x91\x92\x96\x95a\n\xAF\x90\x82\x80a\n{a\nu\x8C\x88Qa7{V[QaBxV[`@Q\x95\x84\x87\x95Q\x91\x82\x91\x01\x84\x87\x01^\x84\x01\x90\x82\x82\x01_\x81R\x81Q\x93\x84\x92\x01\x90^\x01\x01_\x81R\x03`\x1F\x19\x81\x01\x83R\x82a4HV[\x94\x82Q\x87`\x01\x1B\x90\x88\x82\x04`\x02\x14\x89\x15\x17\x15a\n/Wa\n\xD2\x82a\n\xD8\x92a7{V[QaB\xD6V[\x84Q\x90`\x01\x83\x01\x80\x93\x11a\n/W`\x01\x93`\x04\x8C\x81\x93a\n\xFFa\n\xD2\x83\x98a\x0B\xE3\x98a7{V[\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83\x80a\x0BXc\xFF\xFF\xFF\xFF\x86Q`\x02\x1C\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[a\x0B\x8Ec\xFF\xFF\xFF\xFF\x86Q`\x02\x1C\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x95\x84`@Q\x9D\x8B\x8F\x82\x81\x9EQ\x93\x84\x93\x01\x91\x01^\x8B\x01\x92`\xE0\x1B\x16\x83\x83\x01R\x80Q\x92\x83\x91\x01`$\x83\x01^\x01\x01\x92`\xE0\x1B\x16\x84\x83\x01R\x80Q\x92\x83\x91\x01`\x08\x83\x01^\x01\x01_\x83\x82\x01R\x03\x01`\x1F\x19\x81\x01\x83R\x82a4HV[\x96\x01\x91\x90a\x07\xDFV[\x7F\xE6\xD4KL\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$R`D_\xFD[a\x0C2\x81a\x0C,`\x04\x805\x01\x80a4\xEDV[\x90a5AV[a\x0C?` \x82\x01\x82a4\xEDV[\x80\x91P`\x01\x1B\x81\x81\x04`\x02\x14\x82\x15\x17\x15a\n/Wa\x0C\\\x90a6\xF9V[\x90_[\x81\x81\x10a\x19\xE1WPP`\x01`\xFF\x82Qo\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11`\x07\x1Bg\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x82\x1C\x11`\x06\x1B\x17c\xFF\xFF\xFF\xFF\x82\x82\x1C\x11`\x05\x1B\x17a\xFF\xFF\x82\x82\x1C\x11`\x04\x1B\x17\x82\x82\x82\x1C\x11`\x03\x1B\x17`\x0F\x82\x82\x1C\x11`\x02\x1B\x17}\x01\x01\x02\x02\x02\x02\x03\x03\x03\x03\x03\x03\x03\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82\x82\x1C\x1A\x17\x90\x83\x82\x1B\x10\x01\x16\x1Ba\x0C\xF5\x81a6\xF9V[\x91_[\x82\x81\x10a\x19\x86WPP[`\x01\x81\x11a\x19\x07WPa\r\x14\x90a7nV[Q\x90a\r#` \x82\x01\x82a4\xEDV[\x90P_[\x81\x81\x10a\rsWPP`@`\x01\x93\x92a\ra\x83\x7F\x1C\xC9\xA0u]\xD74\xC1\xEB\xFE\x98\xB6\x8E\xCE \x007\xE3c\xEB6m\r\xEE\x04\xE4 \xE2\xF2<\xC0\x10\x94a4\xEDV[\x83Q\x92\x83R` \x83\x01RP\xA1\x01a\x05\x90V[a\r\x8A\x81a\r\x84` \x86\x01\x86a4\xEDV[\x90a5\x81V[\x96a\r\x93a6\x8AV[P` \x88\x01\x90``\x89\x015\x80_R`\x05` R`@_ T\x15a\x18\xDCWP`\xC0\x81\x01Q\x86\x90\x15a\x17dWa\x0E\x04a\x0E\x0F\x93a\r\xEF`\xE0\x85\x01Q`\x80\x86\x01Q`\x01\x1C\x90a\r\xDF6\x85a7\x9CV[a\r\xE9\x83\x83a7{V[Ra7{V[P[a\r\xFB\x88\x80a4\xEDV[\x90\x915\x91a8\xD5V[`@\x8B\x015\x90a:\x95V[\x96a\x0E(a\x0E\x1D\x85\x80a4\xEDV[`\x80\x84\x015\x91a8\xD5V[`\xA0\x82\x015a\x0E5a6\x8AV[P\x80` \x83\x015\x03a\x170WP`\x80\x816\x03\x12a\x01&W`@Qa\x0EX\x81a3\xF3V[\x815\x81R` \x82\x015` \x82\x01R`@\x82\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x82\x01\x90`\x80\x826\x03\x12a\x01&W`@Q\x91a\x0E\x94\x83a3\xF3V[\x805g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa\x0E\xB2\x906\x90\x83\x01a9\xA1V[\x83R` \x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa\x0E\xD5\x906\x90\x83\x01a9\xA1V[` \x84\x01R`@\x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa\x0E\xFB\x906\x90\x83\x01a9\xA1V[`@\x84\x01R``\x81\x015\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&Wa\x0F!\x916\x91\x01a9\xA1V[``\x83\x01R`@\x81\x01\x91\x82R``\x83\x01\x90\x815g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa\x0FP\x906\x90\x86\x01a9\x86V[``\x82\x01Ra\x0F]a7*V[PQ\x91Q`@Q\x92a\x0Fn\x84a3\xF3V[\x83R_` \x84\x01R`@\x83\x01\x89\x90R``\x83\x01R`\xC0\x8B\x01Q\x15a\x16\x01WPa\x0F\xA7\x90a\x01\0\x8B\x01Q`\x80\x8C\x01Q\x91a\r\xE9\x83\x83a7{V[P[a\x0F\xC3a\x0F\xB9`@\x83\x01\x83a8\x88V[`@\x81\x01\x90a4\xEDV[\x90P_[\x81\x81\x10a\x14\x16WPP\x88Q`\x80\x8A\x01\x90a\x0F\xE5\x835\x91\x83Q\x90a7{V[Ra\x10\x08` \x8B\x01Q\x91\x80Q\x90a\x0F\xFB\x82a:hV[\x90R` \x84\x015\x92a7{V[R`\xFF`\x02T\x16`\x01Ta\x10\x1B\x81a:hV[`\x01U\x90\x825\x91_[\x82\x81\x10a\x13pWPP`\x01T`\x01`\xFF`\x02T\x16\x1B\x14a\x13/W[P`@\x8A\x01Ra\x10[a\x10U`@\x83\x01\x83a8\x88V[\x80a4\xEDV[_[\x81\x81\x10a\x12\xCFWPPPa\x10\x81a\x10w`@\x83\x01\x83a8\x88V[` \x81\x01\x90a4\xEDV[_[\x81\x81\x10a\x12oWPPPa\x10\x9Da\x0F\xB9`@\x83\x01\x83a8\x88V[_[\x81\x81\x10a\x11\xFDWPPPa\x10\xC3a\x10\xB9`@\x83\x01\x83a8\x88V[``\x81\x01\x90a4\xEDV[\x90\x91_[\x82\x81\x10a\x11\x81WPPPP``\x88\x01\x80Q`@Q\x92a\x10\xE5\x84a3\xAAV[`\xC0\x81\x015\x84R`\xE0` \x85\x01\x91\x015\x81R`@Q\x93a\x11\x04\x85a3\xAAV[_\x85R_` \x86\x01Ra\x11\x1A\x81Q\x83Q\x90aEcV[\x15a\x11IW\x91a\x11;\x91`\x01\x96\x95\x94\x93` \x83Q\x93\x01Q\x90Q\x91Q\x92aE\xC5V[` \x84\x01R\x82RR\x01a\r'V[`D\x91`@Q\x91\x7F\xB8\xA0\xE8\xA1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83RQ`\x04\x83\x01RQ`$\x82\x01R\xFD[a\x11\x8C\x81\x84\x86a5AV[5\x90`\x02\x82\x10\x15a\x01&W`\x01\x80\x92\x14a\x11\xA7W[\x01a\x10\xC7V[a\x11\xF5\x7F\xA4\x94\xDA\xC4\xB7\x18HCX?\x97.\x06x>,;\xB4\x7FO\x017\xB8\xDFR\xA8`\xDF\x07!\x9F\x8Ca\x11\xE3a\x11\xD9\x84\x88\x8Aa5AV[` \x81\x01\x90a5\xC1V[`@Q\x875\x94\x90\x92\x83\x92\x90\x87\x84aELV[\x03\x90\xA2a\x11\xA1V[a\x12\x08\x81\x83\x85a5AV[5\x90`\x02\x82\x10\x15a\x01&W`\x01\x80\x92\x14a\x12#W[\x01a\x10\x9FV[a\x12g\x7F\x9Ca\xB2\x90\xF61\t\x7FV'<\xF4\xDA\xF4\r\xF1\xFF\x9C\xCC3\xF1\x01\xD4d\x83}\xA1\xF5\xAE\x18\xBDYa\x12Ua\x11\xD9\x84\x87\x89a5AV[`@Q\x895\x94\x90\x92\x83\x92\x90\x87\x84aELV[\x03\x90\xA2a\x12\x1DV[a\x12z\x81\x83\x85a5AV[5\x90`\x02\x82\x10\x15a\x01&W`\x01\x80\x92\x14a\x12\x95W[\x01a\x10\x83V[a\x12\xC7\x7FH$8s\xB4u-\xDC\xB4^\r{\x11\xC4\xC2fX>^\t\x9A\x0By\x8F\xDD\x9C\x1A\xF7\xD4\x93$\xF3a\x12Ua\x11\xD9\x84\x87\x89a5AV[\x03\x90\xA2a\x12\x8FV[a\x12\xDA\x81\x83\x85a5AV[5\x90`\x02\x82\x10\x15a\x01&W`\x01\x80\x92\x14a\x12\xF5W[\x01a\x10]V[a\x13'\x7F:\x13M\x01\xC0x\x03\0<c0\x17\x17\xDD\xC4a.lG\xAE@\x8E\xEE\xA3\",\xDE\xD52\xD0*\xE6a\x12Ua\x11\xD9\x84\x87\x89a5AV[\x03\x90\xA2a\x12\xEFV[\x90a\x13j\x91a\x13=\x82aJ*V[`\x03_R\x7F\xC2WZ\x0E\x9EY<\0\xF9Y\xF8\xC9/\x12\xDB(i\xC39Z;\x05\x02\xD0^%\x16Doq\xF8[\x01T\x90aH)V[\x8Aa\x10?V[\x90\x92`\x01\x90\x81\x85\x16a\x13\xDEW\x7F@W\x87\xFA\x12\xA8#\xE0\xF2\xB7c\x1C\xC4\x1B;\xA8\x82\x8B3!\xCA\x81\x11\x11\xFAu\xCD:\xA3\xBBZ\xCE\x83\x01\x81\x90U`\x03_R\x7F\xC2WZ\x0E\x9EY<\0\xF9Y\xF8\xC9/\x12\xDB(i\xC39Z;\x05\x02\xD0^%\x16Doq\xF8[\x83\x01Ta\x13\xD3\x91aH)V[\x93[\x81\x1C\x91\x01a\x10$V[`\x02_R\x7F@W\x87\xFA\x12\xA8#\xE0\xF2\xB7c\x1C\xC4\x1B;\xA8\x82\x8B3!\xCA\x81\x11\x11\xFAu\xCD:\xA3\xBBZ\xCE\x83\x01Ta\x14\x10\x91\x90aH)V[\x93a\x13\xD5V[a\x14-a\x11\xD9\x82a\x0C,a\x0F\xB9`@\x88\x01\x88a8\x88V[\x81\x01``\x82\x82\x03\x12a\x01&W\x815\x91s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x80\x93\x03a\x01&W` \x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x82a\x14z\x91\x83\x01a9\x86V[\x91`@\x82\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa\x14\x99\x92\x01a9\x86V[\x90`@Q\x91\x7F3\xA8\x92\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83R` \x87\x015`\x04\x84\x01R`@`$\x84\x01R_\x83\x80a\x14\xE2`D\x82\x01\x86aI\xE0V[\x03\x81\x83\x88Z\xF1\x92\x83\x15a\x02\xA9W_\x93a\x15\x85W[P\x82Q` \x84\x01 \x81Q` \x83\x01 \x03a\x15JWP`\x01\x93\x92\x91\x7F\xCD\xDB2z\xDB1\xFET7\xDF*\x8Ch0\x1B\xB1:k\xAA\xE42\xA8\x04\x83\x8C\xAA\xF6\x82Pj\xAD\xF1\x91a\x15A`@Q\x92\x83\x92\x83aJ\x05V[\x03\x90\xA2\x01a\x0F\xC7V[\x90Pa\x15\x81`@Q\x92\x83\x92\x7F\xC5\x04\xFA\xDA\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x84R`\x04\x84\x01aJ\x05V[\x03\x90\xFD[\x90\x92P=\x80_\x83>a\x15\x97\x81\x83a4HV[\x81\x01\x90` \x81\x83\x03\x12a\x01&W\x80Q\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&W\x01\x81`\x1F\x82\x01\x12\x15a\x01&W\x80Q\x90a\x15\xCE\x82a94V[\x92a\x15\xDC`@Q\x94\x85a4HV[\x82\x84R` \x83\x83\x01\x01\x11a\x01&W\x81_\x92` \x80\x93\x01\x83\x86\x01^\x83\x01\x01R\x91\x8Fa\x14\xF6V[a\x16\x0B\x81\x84a5\xC1V[`\x04\x11a\x01&W\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0a\x16>\x915\x16aA\xF8V[`\xA0\x8B\x01Q\x15a\x16PW[PPa\x0F\xA9V[a\x16\xA1\x90` _\x81a\x16\x99s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x94\x88a5\xC1V[\x95\x90\x96aB\xD6V[`@Q\x91\x81\x83\x92Q\x91\x82\x91\x01\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xA9W_Q\x90\x80;\x15a\x01&Wa\x17\x0B\x93_\x93`@Q\x95\x86\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R` \x8B\x015\x91`\x04\x86\x01a8dV[\x03\x91Z\xFA\x80\x15a\x02\xA9Wa\x17 W[\x80a\x16IV[_a\x17*\x91a4HV[\x89a\x17\x1AV[` \x92P\x7F\x18\xF69\xD8\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R\x015`$R`D_\xFD[Pa\x17o\x89\x80a5\xC1V[`\x04\x11a\x01&W\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0a\x17\xA2\x915\x16aA\xF8V[\x85`\xA0\x82\x01Q\x15a\x17\xBAW[a\x0E\x04a\x0E\x0F\x93a\r\xF1V[Ps\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16a\x17\xFC\x8A\x80a5\xC1V[` _\x81a\x18\x12a\x18\r6\x8Aa7\x9CV[aBxV[`@Q\x91\x81\x83\x92Q\x91\x82\x91\x01\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xA9W_Q\x92\x80;\x15a\x01&W_\x92a\x18~\x92`@Q\x95\x86\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R```\x04\x86\x01R`d\x85\x01\x91a8DV[\x90\x7F\x91\x9E\x13\0\x1C\xD31\x9B\xE5\xA5\xA7\xCB\x18\x92\x03\xBE\x086t\xAC\xB3\xFF\xF2=\x05\xAA\xE9\xC3\xED\x861M`$\x84\x01R`D\x83\x01R\x03\x91Z\xFA\x80\x15a\x02\xA9Wa\x0E\x0F\x93\x88\x92a\x0E\x04\x92a\x18\xCCW[P\x93PPa\x17\xAEV[_a\x18\xD6\x91a4HV[\x8Ca\x18\xC3V[\x7F\xF9\x84\x9E\xA3\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[`\x01\x1C_[\x81\x81\x10a\x19\x19WPa\r\x02V[\x80`\x01\x1B\x90\x7F\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x81\x03a\n/Wa\x19Q\x82\x85a7{V[Q\x91`\x01\x81\x01\x80\x91\x11a\n/W`\x01\x92a\x19na\x19u\x92\x87a7{V[Q\x90aH)V[a\x19\x7F\x82\x86a7{V[R\x01a\x19\x0CV[`\x01\x90\x82Q\x81\x10_\x14a\x19\xB0Wa\x19\x9D\x81\x84a7{V[Qa\x19\xA8\x82\x87a7{V[R[\x01a\x0C\xF8V[\x7F\xCC\x1D/\x83\x84E\xDBz\xECC\x1D\xF9\xEE\x8A\x87\x1F@\xE7\xAA^\x06O\xC0Vc>\xF8\xC6\x0F\xAB{\x06a\x19\xDB\x82\x87a7{V[Ra\x19\xAAV[a\x19\xF2\x81a\r\x84` \x87\x01\x87a4\xEDV[\x90\x80`\x01\x1B\x81\x81\x04`\x02\x14\x82\x15\x17\x15a\n/W` \x83\x015a\x1A\x14\x82\x87a7{V[R`\x01\x81\x01\x80\x91\x11a\n/Wa\x1A1`\x80`\x01\x94\x015\x91\x86a7{V[R\x01a\x0C_V[` \x90a\x1ACa7*V[\x82\x82\x8A\x01\x01R\x01a\x054V[P_\x93a\x05\x0CV[` \x90`@Qa\x1Af\x81a3\xF3V[`@Qa\x1Ar\x81a4\x0FV[_\x81R_\x84\x82\x01R_`@\x82\x01R\x81R`@Qa\x1A\x8E\x81a3\xAAV[_\x81R_\x84\x82\x01R\x83\x82\x01R_`@\x82\x01R_``\x82\x01R\x82\x82\x89\x01\x01R\x01a\x04\xFBV[_\x92a\x04\xD3V[\x90\x91a\x1A\xCD\x83a\x0C,`\x04\x805\x01\x80a4\xEDV[\x90a\x1A\xE7a\x1A\xDE` \x84\x01\x84a4\xEDV[\x93\x80\x91Pa4\xEDV[\x92\x80\x91P`\x01\x1B\x90\x80\x82\x04`\x02\x14\x90\x15\x17\x15a\n/W\x80\x83\x03a\x1B\x19WP`\x01\x91a\x1B\x11\x91a7\x8FV[\x92\x01\x90a\x04uV[\x82\x7F\xD3\xBE\xE7\x8D\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$R`D_\xFD[\x7F>\xE5\xAE\xB5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04_\xFD[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `@Q\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x81R\xF3[4a\x01&W` `\x03\x196\x01\x12a\x01&W`\x045_R`\x05` R` `@_ T\x15\x15`@Q\x90\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\x01T`@Q\x90\x81R\xF3[4a\x01&W` `\x03\x196\x01\x12a\x01&W`\x045_R`\x07` R` `@_ T\x15\x15`@Q\x90\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W`\x04T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x01\x90\x81\x11a\n/Wa\x1C\x89` \x91a6EV[\x90T\x90`\x03\x1B\x1C`@Q\x90\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\xFF`\x02T\x16`@Q\x90\x81R\xF3[4a\x01&W` `\x03\x196\x01\x12a\x01&W`\x045`\x06T\x81\x10\x15a\x1D\x08W`\x06_R\x7F\xF6R\"#\x13\xE2\x84YR\x8D\x92\x0Be\x11\\\x16\xC0O>\xFC\x82\xAA\xED\xC9{\xE5\x9F?7|\r?\x01T`@Q\x90\x81R` \x90\xF3[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`2`\x04R`$_\xFD[4a\x01&W_`\x03\x196\x01\x12a\x01&W` s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF_T\x16`@Q\x90\x81R\xF3[4a\x01&W`@`\x03\x196\x01\x12a\x01&Wg\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF`\x045\x11a\x01&W```\x03\x19`\x0456\x03\x01\x12a\x01&W`$5\x80\x15\x15\x80\x91\x03a\x01&WZ\x90\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0\\a\x1BHW`\x01\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0]a\x1D\xFAa4\xB7V[a\x1E\x02a6\x8AV[P_\x90a\x1E\x13`\x04\x805\x01\x80a4\xEDV[_\x91P[\x80\x82\x10a15WPPa\x1E4`D`\x045\x01`\x045`\x04\x01a5\xC1V[\x90P\x15\x15\x91a\x1EB\x81a6\xF9V[\x92a\x1EL\x82a6\xF9V[\x92a\x1EUa6rV[P`@Qa\x1Eb\x81a3\xAAV[_\x80\x82R` \x82\x01R\x82\x15a1.W\x83`\x01\x1C\x93[`\x1F\x19a\x1E\x86a\x05\x1B\x87a6\xE1V[\x01_[\x81\x81\x10a0\xD3WPP\x83\x15a0\xCBW\x94[`\x1F\x19a\x1E\xBFa\x1E\xA9\x88a6\xE1V[\x97a\x1E\xB7`@Q\x99\x8Aa4HV[\x80\x89Ra6\xE1V[\x01_[\x81\x81\x10a0\xB4WPP`@Q\x96a\x1E\xD8\x88a4+V[\x87R` \x87\x01R_`@\x87\x01R``\x86\x01R_`\x80\x86\x01R`\xA0\x85\x01R`\xC0\x84\x01R`\xE0\x83\x01Ra\x01\0\x82\x01R\x90a\x1F\x1A`\x045`\x04\x01`\x045`\x04\x01a4\xEDV[\x90P_[\x81\x81\x10a$DWPP`\x80\x82\x01Qa\x1F\xCFW[\x7F\x10\xDDR\x8D\xB2\xC4\x9A\xDDeEg\x9B\x97m\xF9\r$\xC05\xD6\xA7[\x17\xF4\x1Bp\x0E\x8C\x18\xCASda\x05\xE5\x83a\x1Fw` a\x1F\xA4\x96Q\x92\x01Q`@Q\x93\x84\x93`@\x85R`@\x85\x01\x90a6\x12V[\x03\x90\xA1_\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0]Z\x90a3\x9DV[\x7Fo\x14\x981\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[a\x06qa \x1Fa\x1F\xE9`$`\x045\x01`\x045`\x04\x01a5\xC1V[\x91\x90a\x1F\xFF`D`\x045\x01`\x045`\x04\x01a5\xC1V[\x94\x90\x93a\x06k``\x89\x01Q\x93\x89Q` \x81Q`\x05\x1B\x91\x01 \x926\x91a9PV[` \x81Q\x91\x01Q\x90_R` Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x80`@_ \x16\x91\x16\x90\x80\x82\x03a\x0B\xECWPP`\xC0\x84\x01Qa \xFBW[PP`@\x82\x01Q\x91a n\x83aL\xA2V[\x15a \xCFWa\x05\xE5\x7F\x10\xDDR\x8D\xB2\xC4\x9A\xDDeEg\x9B\x97m\xF9\r$\xC05\xD6\xA7[\x17\xF4\x1Bp\x0E\x8C\x18\xCASd\x91\x7F\n-\xC5H\xED\x95\n\xCC\xB4\r]xT\x1F9T\xC5\xE1\x82\xA8\xEC\xF1\x9EX\x1AO\"c\xF6\x1FY\xD2` a\x1F\xA4\x96`@Q\x90\x81R\xA1\x93PPPa\x1F1V[\x82\x7F\xDBx\x8C+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[\x81`\x04\x11a\x01&Wa!/\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x825\x16aA\xF8V[` \x84\x01Q`\xE0\x85\x01Qa\x01\0\x86\x01Q\x90`@Q\x92a!M\x84a4\x0FV[\x83R` \x83\x01\x90\x80\x82R`@\x84\x01\x92\x83RQ\x92` \x93`@Qa!p\x86\x82a4HV[_\x81R\x92`@Qa!\x81\x87\x82a4HV[_\x81R\x94_\x91[\x87\x84\x84\x10a#\xD8WPPPPa!\xC6c\xFF\xFF\xFF\xFF\x82\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x93\x81`\x01\x1B\x91\x80\x83\x04`\x02\x14\x90\x15\x17\x15a\n/W`$\x86a\"\x11c\xFF\xFF\xFF\xFF`(\x95\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x94Q\x94\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82`@Q\x98\x82\x82\x8B\x01\x9B`\xE0\x1B\x16\x8BR\x80Q\x91\x82\x91\x01\x86\x8B\x01^\x88\x01\x91\x7F\x91\x9E\x13\0\x1C\xD31\x9B\xE5\xA5\xA7\xCB\x18\x92\x03\xBE\x086t\xAC\xB3\xFF\xF2=\x05\xAA\xE9\xC3\xED\x861M\x85\x84\x01R`\xE0\x1B\x16\x93\x84`D\x83\x01R\x80Q\x92\x83\x91\x01`H\x83\x01^\x01\x01\x90`$\x82\x01R\x01\x84\x82Q\x91\x92\x01\x90_[\x86\x82\x82\x10a#\xC4WPPPP\x90a\"\xC1\x81_\x94\x93\x03`\x1F\x19\x81\x01\x83R\x82a4HV[`@Q\x91\x82\x91Q\x80\x91\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xA9W_Q\x91`\xA0\x85\x01Q\x15a\"\xF0W[Pa ]V[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x80;\x15a\x01&W_\x92a#r\x92`@Q\x95\x86\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R```\x04\x86\x01R`d\x85\x01\x91a8DV[\x90\x7F!;?@\xD7\xC1\x13\xC1\xA0\x12\x07/\xCDy\x1F\xA4K\xF5\x16j#\0\x12\x160\xBD2(\xE2\xB0\x08'`$\x84\x01R`D\x83\x01R\x03\x91Z\xFA\x80\x15a\x02\xA9Wa#\xB4W[\x80\x80a\"\xEAV[_a#\xBE\x91a4HV[\x82a#\xADV[\x83Q\x85R\x93\x84\x01\x93\x90\x92\x01\x91`\x01\x01a\"\x9FV[\x90\x91\x92\x96\x95a#\xF1\x90\x82\x80a\n{a\nu\x8C\x88Qa7{V[\x94\x82Q\x87`\x01\x1B\x90\x88\x82\x04`\x02\x14\x89\x15\x17\x15a\n/Wa\n\xD2\x82a$\x14\x92a7{V[\x84Q\x90`\x01\x83\x01\x80\x93\x11a\n/W`\x01\x93`\x04\x8C\x81\x93a\n\xFFa\n\xD2\x83\x98a$;\x98a7{V[\x96\x01\x91\x90a!\x88V[a$V\x81a\x0C,`\x04\x805\x01\x80a4\xEDV[a$c` \x82\x01\x82a4\xEDV[\x80\x91P`\x01\x1B\x81\x81\x04`\x02\x14\x82\x15\x17\x15a\n/Wa$\x80\x90a6\xF9V[\x90_[\x81\x81\x10a0]WPP`\x01`\xFF\x82Qo\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11`\x07\x1Bg\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x82\x1C\x11`\x06\x1B\x17c\xFF\xFF\xFF\xFF\x82\x82\x1C\x11`\x05\x1B\x17a\xFF\xFF\x82\x82\x1C\x11`\x04\x1B\x17\x82\x82\x82\x1C\x11`\x03\x1B\x17`\x0F\x82\x82\x1C\x11`\x02\x1B\x17}\x01\x01\x02\x02\x02\x02\x03\x03\x03\x03\x03\x03\x03\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82\x82\x1C\x1A\x17\x90\x83\x82\x1B\x10\x01\x16\x1Ba%\x19\x81a6\xF9V[\x91_[\x82\x81\x10a0\x02WPP[`\x01\x81\x11a/\x8AWPa%8\x90a7nV[Q\x90a%G` \x82\x01\x82a4\xEDV[\x90P_[\x81\x81\x10a%\x97WPP`@`\x01\x93\x92a%\x85\x83\x7F\x1C\xC9\xA0u]\xD74\xC1\xEB\xFE\x98\xB6\x8E\xCE \x007\xE3c\xEB6m\r\xEE\x04\xE4 \xE2\xF2<\xC0\x10\x94a4\xEDV[\x83Q\x92\x83R` \x83\x01RP\xA1\x01a\x1F\x1EV[a%\xA8\x81a\r\x84` \x86\x01\x86a4\xEDV[\x97a%\xB1a6\x8AV[P` \x89\x01\x90``\x8A\x015\x80_R`\x05` R`@_ T\x15a\x18\xDCWP`\xC0\x81\x01Q\x86\x90\x15a.\x17Wa%\xFDa&\x08\x93a\r\xEF`\xE0\x85\x01Q`\x80\x86\x01Q`\x01\x1C\x90a\r\xDF6\x85a7\x9CV[`@\x8C\x015\x90a:\x95V[\x97a&\x16a\x0E\x1D\x85\x80a4\xEDV[`\xA0\x82\x015a&#a6\x8AV[P\x80` \x83\x015\x03a\x170WP`\x80\x816\x03\x12a\x01&W`@Qa&F\x81a3\xF3V[\x815\x81R` \x82\x015` \x82\x01R`@\x82\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x82\x01\x90`\x80\x826\x03\x12a\x01&W`@Q\x91a&\x82\x83a3\xF3V[\x805g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa&\xA0\x906\x90\x83\x01a9\xA1V[\x83R` \x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa&\xC3\x906\x90\x83\x01a9\xA1V[` \x84\x01R`@\x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa&\xE9\x906\x90\x83\x01a9\xA1V[`@\x84\x01R``\x81\x015\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&Wa'\x0F\x916\x91\x01a9\xA1V[``\x83\x01R`@\x81\x01\x91\x82R``\x83\x01\x90\x815g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa'>\x906\x90\x86\x01a9\x86V[``\x82\x01Ra'Ka7*V[PQ\x91Q`@Q\x92a'\\\x84a3\xF3V[\x83R_` \x84\x01R`@\x83\x01\x89\x90R``\x83\x01R`\xC0\x8C\x01Q\x15a,\xF0WPa'\x95\x90a\x01\0\x8C\x01Q`\x80\x8D\x01Q\x91a\r\xE9\x83\x83a7{V[P[a'\xA7a\x0F\xB9`@\x83\x01\x83a8\x88V[\x90P_[\x81\x81\x10a+@WPP\x89Q`\x80\x8B\x01\x90a'\xC9\x835\x91\x83Q\x90a7{V[Ra'\xDF` \x8C\x01Q\x91\x80Q\x90a\x0F\xFB\x82a:hV[R`\xFF`\x02T\x16`\x01Ta'\xF2\x81a:hV[`\x01U\x90\x825\x91_[\x82\x81\x10a*\x9AWPP`\x01T`\x01`\xFF`\x02T\x16\x1B\x14a*\x86W[P`@\x8B\x01Ra(,a\x10U`@\x83\x01\x83a8\x88V[_[\x81\x81\x10a*&WPPPa(Ha\x10w`@\x83\x01\x83a8\x88V[_[\x81\x81\x10a)\xC6WPPPa(da\x0F\xB9`@\x83\x01\x83a8\x88V[_[\x81\x81\x10a)fWPPPa(\x80a\x10\xB9`@\x83\x01\x83a8\x88V[\x90\x91_[\x82\x81\x10a)\x06WPPPP``\x89\x01\x80Q`@Q\x92a(\xA2\x84a3\xAAV[`\xC0\x81\x015\x84R`\xE0` \x85\x01\x91\x015\x81R`@Q\x93a(\xC1\x85a3\xAAV[_\x85R_` \x86\x01Ra(\xD7\x81Q\x83Q\x90aEcV[\x15a\x11IW\x91a(\xF8\x91`\x01\x96\x95\x94\x93` \x83Q\x93\x01Q\x90Q\x91Q\x92aE\xC5V[` \x84\x01R\x82RR\x01a%KV[a)\x11\x81\x84\x86a5AV[5\x90`\x02\x82\x10\x15a\x01&W`\x01\x80\x92\x14a),W[\x01a(\x84V[a)^\x7F\xA4\x94\xDA\xC4\xB7\x18HCX?\x97.\x06x>,;\xB4\x7FO\x017\xB8\xDFR\xA8`\xDF\x07!\x9F\x8Ca\x11\xE3a\x11\xD9\x84\x88\x8Aa5AV[\x03\x90\xA2a)&V[a)q\x81\x83\x85a5AV[5\x90`\x02\x82\x10\x15a\x01&W`\x01\x80\x92\x14a)\x8CW[\x01a(fV[a)\xBE\x7F\x9Ca\xB2\x90\xF61\t\x7FV'<\xF4\xDA\xF4\r\xF1\xFF\x9C\xCC3\xF1\x01\xD4d\x83}\xA1\xF5\xAE\x18\xBDYa\x12Ua\x11\xD9\x84\x87\x89a5AV[\x03\x90\xA2a)\x86V[a)\xD1\x81\x83\x85a5AV[5\x90`\x02\x82\x10\x15a\x01&W`\x01\x80\x92\x14a)\xECW[\x01a(JV[a*\x1E\x7FH$8s\xB4u-\xDC\xB4^\r{\x11\xC4\xC2fX>^\t\x9A\x0By\x8F\xDD\x9C\x1A\xF7\xD4\x93$\xF3a\x12Ua\x11\xD9\x84\x87\x89a5AV[\x03\x90\xA2a)\xE6V[a*1\x81\x83\x85a5AV[5\x90`\x02\x82\x10\x15a\x01&W`\x01\x80\x92\x14a*LW[\x01a(.V[a*~\x7F:\x13M\x01\xC0x\x03\0<c0\x17\x17\xDD\xC4a.lG\xAE@\x8E\xEE\xA3\",\xDE\xD52\xD0*\xE6a\x12Ua\x11\xD9\x84\x87\x89a5AV[\x03\x90\xA2a*FV[\x90a*\x94\x91a\x13=\x82aJ*V[\x8Ba(\x16V[\x90\x92`\x01\x90\x81\x85\x16a+\x08W\x7F@W\x87\xFA\x12\xA8#\xE0\xF2\xB7c\x1C\xC4\x1B;\xA8\x82\x8B3!\xCA\x81\x11\x11\xFAu\xCD:\xA3\xBBZ\xCE\x83\x01\x81\x90U`\x03_R\x7F\xC2WZ\x0E\x9EY<\0\xF9Y\xF8\xC9/\x12\xDB(i\xC39Z;\x05\x02\xD0^%\x16Doq\xF8[\x83\x01Ta*\xFD\x91aH)V[\x93[\x81\x1C\x91\x01a'\xFBV[`\x02_R\x7F@W\x87\xFA\x12\xA8#\xE0\xF2\xB7c\x1C\xC4\x1B;\xA8\x82\x8B3!\xCA\x81\x11\x11\xFAu\xCD:\xA3\xBBZ\xCE\x83\x01Ta+:\x91\x90aH)V[\x93a*\xFFV[a+Wa\x11\xD9\x82a\x0C,a\x0F\xB9`@\x88\x01\x88a8\x88V[\x81\x01``\x82\x82\x03\x12a\x01&W\x815\x91s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x80\x93\x03a\x01&W` \x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x82a+\xA4\x91\x83\x01a9\x86V[\x91`@\x82\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa+\xC3\x92\x01a9\x86V[\x90`@Q\x91\x7F3\xA8\x92\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83R` \x87\x015`\x04\x84\x01R`@`$\x84\x01R_\x83\x80a,\x0C`D\x82\x01\x86aI\xE0V[\x03\x81\x83\x88Z\xF1\x92\x83\x15a\x02\xA9W_\x93a,tW[P\x82Q` \x84\x01 \x81Q` \x83\x01 \x03a\x15JWP`\x01\x93\x92\x91\x7F\xCD\xDB2z\xDB1\xFET7\xDF*\x8Ch0\x1B\xB1:k\xAA\xE42\xA8\x04\x83\x8C\xAA\xF6\x82Pj\xAD\xF1\x91a,k`@Q\x92\x83\x92\x83aJ\x05V[\x03\x90\xA2\x01a'\xABV[\x90\x92P=\x80_\x83>a,\x86\x81\x83a4HV[\x81\x01\x90` \x81\x83\x03\x12a\x01&W\x80Q\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&W\x01\x81`\x1F\x82\x01\x12\x15a\x01&W\x80Q\x90a,\xBD\x82a94V[\x92a,\xCB`@Q\x94\x85a4HV[\x82\x84R` \x83\x83\x01\x01\x11a\x01&W\x81_\x92` \x80\x93\x01\x83\x86\x01^\x83\x01\x01R\x91_a, V[a,\xFA\x81\x84a5\xC1V[`\x04\x11a\x01&W\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0a--\x915\x16aA\xF8V[`\xA0\x8C\x01Q\x15a-?W[PPa'\x97V[a-\x88\x90` _\x81a\x16\x99s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x94\x88a5\xC1V[`@Q\x91\x81\x83\x92Q\x91\x82\x91\x01\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xA9W_Q\x90\x80;\x15a\x01&Wa-\xF2\x93_\x93`@Q\x95\x86\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R` \x8B\x015\x91`\x04\x86\x01a8dV[\x03\x91Z\xFA\x80\x15a\x02\xA9Wa.\x07W[\x80a-8V[_a.\x11\x91a4HV[\x8Aa.\x01V[Pa.\"\x8A\x80a5\xC1V[`\x04\x11a\x01&W\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0a.U\x915\x16aA\xF8V[\x85`\xA0\x82\x01Q\x15a.mW[a%\xFDa&\x08\x93a\r\xF1V[Ps\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16a.\xAF\x8B\x80a5\xC1V[` _\x81a.\xC0a\x18\r6\x8Aa7\x9CV[`@Q\x91\x81\x83\x92Q\x91\x82\x91\x01\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xA9W_Q\x92\x80;\x15a\x01&W_\x92a/,\x92`@Q\x95\x86\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R```\x04\x86\x01R`d\x85\x01\x91a8DV[\x90\x7F\x91\x9E\x13\0\x1C\xD31\x9B\xE5\xA5\xA7\xCB\x18\x92\x03\xBE\x086t\xAC\xB3\xFF\xF2=\x05\xAA\xE9\xC3\xED\x861M`$\x84\x01R`D\x83\x01R\x03\x91Z\xFA\x80\x15a\x02\xA9Wa&\x08\x93\x88\x92a%\xFD\x92a/zW[P\x93PPa.aV[_a/\x84\x91a4HV[\x8Da/qV[`\x01\x1C_[\x81\x81\x10a/\x9CWPa%&V[\x80`\x01\x1B\x90\x7F\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x81\x03a\n/Wa/\xD4\x82\x85a7{V[Q\x91`\x01\x81\x01\x80\x91\x11a\n/W`\x01\x92a\x19na/\xF1\x92\x87a7{V[a/\xFB\x82\x86a7{V[R\x01a/\x8FV[`\x01\x90\x82Q\x81\x10_\x14a0,Wa0\x19\x81\x84a7{V[Qa0$\x82\x87a7{V[R[\x01a%\x1CV[\x7F\xCC\x1D/\x83\x84E\xDBz\xECC\x1D\xF9\xEE\x8A\x87\x1F@\xE7\xAA^\x06O\xC0Vc>\xF8\xC6\x0F\xAB{\x06a0W\x82\x87a7{V[Ra0&V[a0n\x81a\r\x84` \x87\x01\x87a4\xEDV[\x90\x80`\x01\x1B\x81\x81\x04`\x02\x14\x82\x15\x17\x15a\n/W` \x83\x015a0\x90\x82\x87a7{V[R`\x01\x81\x01\x80\x91\x11a\n/Wa0\xAD`\x80`\x01\x94\x015\x91\x86a7{V[R\x01a$\x83V[` \x90a0\xBFa7*V[\x82\x82\x8B\x01\x01R\x01a\x1E\xC2V[P_\x94a\x1E\x9AV[` \x90`@Qa0\xE2\x81a3\xF3V[`@Qa0\xEE\x81a4\x0FV[_\x81R_\x84\x82\x01R_`@\x82\x01R\x81R`@Qa1\n\x81a3\xAAV[_\x81R_\x84\x82\x01R\x83\x82\x01R_`@\x82\x01R_``\x82\x01R\x82\x82\x8A\x01\x01R\x01a\x1E\x89V[_\x93a\x1EwV[\x90\x92a1I\x84a\x0C,`\x04\x805\x01\x80a4\xEDV[\x90a1Za\x1A\xDE` \x84\x01\x84a4\xEDV[\x92\x80\x91P`\x01\x1B\x90\x80\x82\x04`\x02\x14\x90\x15\x17\x15a\n/W\x80\x83\x03a\x1B\x19WP`\x01\x91a1\x84\x91a7\x8FV[\x93\x01\x90a\x1E\x17V[4a\x01&W_`\x03\x196\x01\x12a\x01&Wa1\xA4a4kV[_s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81\x16\x83U\x16\x7F\x8B\xE0\x07\x9CS\x16Y\x14\x13D\xCD\x1F\xD0\xA4\xF2\x84\x19I\x7F\x97\"\xA3\xDA\xAF\xE3\xB4\x18okdW\xE0\x82\x80\xA3\0[4a\x01&W_`\x03\x196\x01\x12a\x01&Wa2 a4kV[a2(a4\xB7V[a20a4\xB7V[t\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF_T\x16\x17_U\x7Fb\xE7\x8C\xEA\x01\xBE\xE3 \xCDNB\x02p\xB5\xEAt\0\r\x11\xB0\xC9\xF7GT\xEB\xDB\xFCTK\x05\xA2X` `@Q3\x81R\xA1\0[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\xFF_T`\xA0\x1C\x16`@Q\x90\x15\x15\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `@Qs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\x04T`@Q\x90\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\x06T`@Q\x90\x81R\xF3[4a\x01&W` `\x03\x196\x01\x12a\x01&W` a\x1C\x89`\x045a6EV[4a\x01&W_`\x03\x196\x01\x12a\x01&W\x80\x7F1.1.0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0` \x92R\xF3[\x91\x90\x82\x03\x91\x82\x11a\n/WV[`@\x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a3\xC6W`@RV[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`A`\x04R`$_\xFD[`\x80\x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a3\xC6W`@RV[``\x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a3\xC6W`@RV[a\x01 \x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a3\xC6W`@RV[\x90`\x1F`\x1F\x19\x91\x01\x16\x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a3\xC6W`@RV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF_T\x163\x03a4\x8BWV[\x7F\x11\x8C\xDA\xA7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R3`\x04R`$_\xFD[`\xFF_T`\xA0\x1C\x16a4\xC5WV[\x7F\xD9<\x06e\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04_\xFD[\x905\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE1\x816\x03\x01\x82\x12\x15a\x01&W\x01\x805\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&W` \x01\x91\x81`\x05\x1B6\x03\x83\x13a\x01&WV[\x91\x90\x81\x10\x15a\x1D\x08W`\x05\x1B\x81\x015\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xC1\x816\x03\x01\x82\x12\x15a\x01&W\x01\x90V[\x91\x90\x81\x10\x15a\x1D\x08W`\x05\x1B\x81\x015\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x01\x816\x03\x01\x82\x12\x15a\x01&W\x01\x90V[\x905\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE1\x816\x03\x01\x82\x12\x15a\x01&W\x01\x805\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&W` \x01\x91\x816\x03\x83\x13a\x01&WV[\x90` \x80\x83Q\x92\x83\x81R\x01\x92\x01\x90_[\x81\x81\x10a6/WPPP\x90V[\x82Q\x84R` \x93\x84\x01\x93\x90\x92\x01\x91`\x01\x01a6\"V[`\x04T\x81\x10\x15a\x1D\x08W`\x04_R` _ \x01\x90_\x90V[\x80T\x82\x10\x15a\x1D\x08W_R` _ \x01\x90_\x90V[`@Q\x90a6\x7F\x82a3\xAAV[_` \x83\x82\x81R\x01RV[`@Q\x90a6\x97\x82a4+V[``a\x01\0\x83\x82\x81R\x82` \x82\x01R_`@\x82\x01R`@Qa6\xB8\x81a3\xAAV[_\x81R_` \x82\x01R\x83\x82\x01R_`\x80\x82\x01R_`\xA0\x82\x01R_`\xC0\x82\x01R\x82`\xE0\x82\x01R\x01RV[g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a3\xC6W`\x05\x1B` \x01\x90V[\x90a7\x03\x82a6\xE1V[a7\x10`@Q\x91\x82a4HV[\x82\x81R`\x1F\x19a7 \x82\x94a6\xE1V[\x01\x90` 6\x91\x017V[`@Q\x90a77\x82a3\xF3V[\x81_\x81R_` \x82\x01R_`@\x82\x01R```@Q\x91a7V\x83a3\xF3V[\x81\x83R\x81` \x84\x01R\x81`@\x84\x01R\x81\x80\x84\x01R\x01RV[\x80Q\x15a\x1D\x08W` \x01\x90V[\x80Q\x82\x10\x15a\x1D\x08W` \x91`\x05\x1B\x01\x01\x90V[\x91\x90\x82\x01\x80\x92\x11a\n/WV[\x80\x92\x91\x03\x91`\xE0\x83\x12a\x01&W`@Q\x90a7\xB6\x82a3\xF3V[\x81\x93``\x81\x12a\x01&W\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xA0`@\x91\x82Qa7\xEF\x81a4\x0FV[\x845\x81R` \x85\x015` \x82\x01R\x83\x85\x015\x84\x82\x01R\x85R\x01\x12a\x01&W`\xC0``\x91`@Qa8\x1E\x81a3\xAAV[\x83\x82\x015\x81R`\x80\x82\x015` \x82\x01R` \x85\x01R`\xA0\x81\x015`@\x85\x01R\x015\x91\x01RV[`\x1F\x82` \x94\x93`\x1F\x19\x93\x81\x86R\x86\x86\x017_\x85\x82\x86\x01\x01R\x01\x16\x01\x01\x90V[\x90a8~\x90`@\x93\x96\x95\x94\x96``\x84R``\x84\x01\x91a8DV[\x94` \x82\x01R\x01RV[\x905\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x816\x03\x01\x82\x12\x15a\x01&W\x01\x90V[\x90\x82\x10\x15a\x1D\x08Wa8\xD2\x91`\x05\x1B\x81\x01\x90a8\x88V[\x90V[\x90\x92\x91\x92_[\x81\x81\x10a9\x0EW\x84\x7F\x89!\x14t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[\x84a9\x1A\x82\x84\x86a8\xBBV[5\x14a9(W`\x01\x01a8\xDBV[\x91a8\xD2\x93\x94Pa8\xBBV[g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a3\xC6W`\x1F\x01`\x1F\x19\x16` \x01\x90V[\x92\x91\x92a9\\\x82a94V[\x91a9j`@Q\x93\x84a4HV[\x82\x94\x81\x84R\x81\x83\x01\x11a\x01&W\x82\x81` \x93\x84_\x96\x017\x01\x01RV[\x90\x80`\x1F\x83\x01\x12\x15a\x01&W\x81` a8\xD2\x935\x91\x01a9PV[\x90\x80`\x1F\x83\x01\x12\x15a\x01&W\x815\x91a9\xB9\x83a6\xE1V[\x92a9\xC7`@Q\x94\x85a4HV[\x80\x84R` \x80\x85\x01\x91`\x05\x1B\x83\x01\x01\x91\x83\x83\x11a\x01&W` \x81\x01\x91[\x83\x83\x10a9\xF3WPPPPP\x90V[\x825g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x82\x01\x90`@`\x1F\x19\x83\x88\x03\x01\x12a\x01&W`@Q\x90a:\"\x82a3\xAAV[` \x83\x015`\x02\x81\x10\x15a\x01&W\x82R`@\x83\x015\x91g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x11a\x01&Wa:Y\x88` \x80\x96\x95\x81\x96\x01\x01a9\x86V[\x83\x82\x01R\x81R\x01\x92\x01\x91a9\xE4V[\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x14a\n/W`\x01\x01\x90V[\x93\x92\x90\x91a:\xA1a6\x8AV[P\x81\x94_\x93` \x82\x015\x90\x80\x82\x03aA\xCAWP`\x80\x826\x03\x12a\x01&W`@Q\x93a:\xCB\x85a3\xF3V[\x825\x94\x85\x81R\x82` \x82\x01R`@\x84\x01\x94\x855g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x85\x01\x90`\x80\x826\x03\x12a\x01&W`@Q\x91a;\x07\x83a3\xF3V[\x805g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa;%\x906\x90\x83\x01a9\xA1V[\x83R` \x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa;H\x906\x90\x83\x01a9\xA1V[` \x84\x01R`@\x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa;n\x906\x90\x83\x01a9\xA1V[`@\x84\x01R``\x81\x015\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&Wa;\x94\x916\x91\x01a9\xA1V[``\x83\x01R`@\x83\x01\x91\x82R``\x86\x01\x92\x835g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa;\xC3\x906\x90\x89\x01a9\x86V[``\x82\x01Ra;\xD0a7*V[PQ\x91Q\x90`@Q\x92a;\xE2\x84a3\xF3V[\x83R`\x01` \x84\x01R`@\x83\x01R``\x82\x01R`\xC0\x83\x01Q\x15a@\x9BWa<\x1A\x91Pa\x01\0\x83\x01Q`\x80\x84\x01Q\x91a\r\xE9\x83\x83a7{V[P[a<)a\x0F\xB9\x85\x85a8\x88V[\x90P\x86[\x81\x81\x10a>\xD0WPP\x80` a<f\x92Q\x91\x87a<P`\x80\x83\x01\x94\x85Q\x90a7{V[R\x01Q\x81Q\x91a<_\x83a:hV[\x90Ra7{V[Ra<p\x83aL\xDBV[\x15a>\xA4Wa<\x82a\x10U\x83\x83a8\x88V[\x85[\x81\x81\x10a>5WPPPa<\x9Ba\x10w\x83\x83a8\x88V[\x85[\x81\x81\x10a=\xC6WPPPa<\xB4a\x0F\xB9\x83\x83a8\x88V[\x85[\x81\x81\x10a=SWPPPa<\xCD\x91a\x10\xB9\x91a8\x88V[\x83\x92\x91\x92[\x81\x81\x10a<\xE0WPPPPPV[a<\xEB\x81\x83\x86a5AV[5`\x02\x81\x10\x15a=OW\x90`\x01\x80\x92\x14a=\x06W[\x01a<\xD2V[\x83\x7F\xA4\x94\xDA\xC4\xB7\x18HCX?\x97.\x06x>,;\xB4\x7FO\x017\xB8\xDFR\xA8`\xDF\x07!\x9F\x8Ca=6a\x11\xD9\x84\x87\x8Aa5AV[\x90a=G`@Q\x92\x83\x92\x87\x84aELV[\x03\x90\xA2a=\0V[\x85\x80\xFD[a=^\x81\x83\x85a5AV[5`\x02\x81\x10\x15a=\xC2W\x90`\x01\x80\x92\x14a=yW[\x01a<\xB6V[\x86\x7F\x9Ca\xB2\x90\xF61\t\x7FV'<\xF4\xDA\xF4\r\xF1\xFF\x9C\xCC3\xF1\x01\xD4d\x83}\xA1\xF5\xAE\x18\xBDYa=\xA9a\x11\xD9\x84\x87\x89a5AV[\x90a=\xBA`@Q\x92\x83\x92\x87\x84aELV[\x03\x90\xA2a=sV[\x87\x80\xFD[a=\xD1\x81\x83\x85a5AV[5`\x02\x81\x10\x15a=\xC2W\x90`\x01\x80\x92\x14a=\xECW[\x01a<\x9DV[\x86\x7FH$8s\xB4u-\xDC\xB4^\r{\x11\xC4\xC2fX>^\t\x9A\x0By\x8F\xDD\x9C\x1A\xF7\xD4\x93$\xF3a>\x1Ca\x11\xD9\x84\x87\x89a5AV[\x90a>-`@Q\x92\x83\x92\x87\x84aELV[\x03\x90\xA2a=\xE6V[a>@\x81\x83\x85a5AV[5`\x02\x81\x10\x15a=\xC2W\x90`\x01\x80\x92\x14a>[W[\x01a<\x84V[\x86\x7F:\x13M\x01\xC0x\x03\0<c0\x17\x17\xDD\xC4a.lG\xAE@\x8E\xEE\xA3\",\xDE\xD52\xD0*\xE6a>\x8Ba\x11\xD9\x84\x87\x89a5AV[\x90a>\x9C`@Q\x92\x83\x92\x87\x84aELV[\x03\x90\xA2a>UV[`$\x84\x84\x7F9\xA9@\xC5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82R`\x04R\xFD[a>\xE4a\x11\xD9\x82a\x0C,a\x0F\xB9\x8A\x8Aa8\x88V[\x81\x01\x90``\x81\x83\x03\x12a@\x97W\x805\x91s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x80\x93\x03a@\x93W` \x82\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a@\x8FW\x81a?2\x91\x84\x01a9\x86V[\x91`@\x81\x015\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a@\x80Wa?S\x92\x91\x01a9\x86V[\x90`@Q\x91\x7F3\xA8\x92\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83R\x87`\x04\x84\x01R`@`$\x84\x01R\x8B\x83\x80a?\x98`D\x82\x01\x86aI\xE0V[\x03\x81\x83\x88Z\xF1\x92\x83\x15a@\x84W\x8C\x93a@\0W[P\x82Q` \x84\x01 \x81Q` \x83\x01 \x03a\x15JWP`\x01\x93\x92\x91\x7F\xCD\xDB2z\xDB1\xFET7\xDF*\x8Ch0\x1B\xB1:k\xAA\xE42\xA8\x04\x83\x8C\xAA\xF6\x82Pj\xAD\xF1\x91a?\xF7`@Q\x92\x83\x92\x83aJ\x05V[\x03\x90\xA2\x01a<-V[\x90\x92P=\x80\x8D\x83>a@\x12\x81\x83a4HV[\x81\x01\x90` \x81\x83\x03\x12a@\x80W\x80Q\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a@|W\x01\x81`\x1F\x82\x01\x12\x15a@\x80W\x80Q\x90a@I\x82a94V[\x92a@W`@Q\x94\x85a4HV[\x82\x84R` \x83\x83\x01\x01\x11a@|W\x81\x8E\x92` \x80\x93\x01\x83\x86\x01^\x83\x01\x01R\x91_a?\xACV[\x8D\x80\xFD[\x8C\x80\xFD[`@Q=\x8E\x82>=\x90\xFD[\x8B\x80\xFD[\x8A\x80\xFD[\x89\x80\xFD[a@\xA5\x82\x86a5\xC1V[`\x04\x11a\x01&W\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0a@\xD8\x915\x16aA\xF8V[`\xA0\x83\x01Q\x15a@\xEAW[PPa<\x1CV[aA;\x90` _\x81aA3s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x96\x8Aa5\xC1V[\x95\x90\x94aB\xD6V[`@Q\x91\x81\x83\x92Q\x91\x82\x91\x01\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xA9W_Q\x92\x80;\x15a\x01&W_\x92\x86\x92aA\xA0`@Q\x96\x87\x95\x86\x94\x85\x94\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x86R`\x04\x86\x01a8dV[\x03\x91Z\xFA\x80\x15a\x02\xA9WaA\xB5W[\x80a@\xE3V[aA\xC2\x91\x96P_\x90a4HV[_\x94_aA\xAFV[\x7F\x18\xF69\xD8\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$R`D_\xFD[\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x80\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x91\x16\x90\x80\x82\x03aBJWPPV[\x7Fx\xA2\"\x1C\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$R`D_\xFD[\x80Q\x80Q\x91`@` \x83\x01Q\x92\x01Q` \x82\x01Q` \x81Q\x91\x01Q\x91```@\x85\x01Q\x94\x01Q\x94`@Q\x96` \x88\x01R`@\x87\x01R``\x86\x01R`\x80\x85\x01R`\xA0\x84\x01R`\xC0\x83\x01R`\xE0\x82\x01R`\xE0\x81Ra8\xD2a\x01\0\x82a4HV[``\x81\x01Q\x81Q` \x83\x01Q\x90\x91\x90\x15aECW`@c\x01\0\0\0\x93[\x01Q\x90\x80Q\x90\x81Qc\xFF\xFF\xFF\xFF\x16aC-\x90b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x91aC7\x90aHlV[` \x82\x01Q\x80Qc\xFF\xFF\xFF\xFF\x16aCp\x90b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x90aCz\x90aHlV[\x90`@\x84\x01Q\x92\x83Qc\xFF\xFF\xFF\xFF\x16aC\xB5\x90b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x93aC\xBF\x90aHlV[\x94``\x01Q\x95\x86Qc\xFF\xFF\xFF\xFF\x16aC\xF9\x90b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x96aD\x03\x90aHlV[\x97`@Q\x9A\x8B\x9A` \x8C\x01R`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`@\x8B\x01R`D\x8A\x01R`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`d\x89\x01R\x80Q` \x81\x92\x01`h\x8A\x01^\x87\x01\x90`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`h\x82\x01R\x81Q` \x81\x93\x01`l\x83\x01^\x01`h\x01\x90`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`\x04\x82\x01R\x81Q` \x81\x93\x01`\x08\x83\x01^\x01`\x04\x01\x90`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`\x04\x82\x01R\x81Q` \x81\x93\x01`\x08\x83\x01^\x01`\x04\x01`\x04\x81\x01_\x90R\x03`\x04\x01`\x1F\x19\x81\x01\x82Ra8\xD2\x90\x82a4HV[`@_\x93aB\xF3V[`@\x90a8\xD2\x94\x92\x81R\x81` \x82\x01R\x01\x91a8DV[\x80\x15\x80\x15aE\xB5W[\x80\x15aE\xADW[\x80\x15aE\x9DW[aE\x97Wd\x01\0\0\x03\xD0\x19`\x07\x81\x80\x93\x81\x81\x80\t\t\x08\x91\x80\t\x14\x90V[PP_\x90V[Pd\x01\0\0\x03\xD0\x19\x82\x10\x15aEzV[P\x81\x15aEsV[Pd\x01\0\0\x03\xD0\x19\x81\x10\x15aElV[\x90\x93\x92\x90\x91_\x90\x80\x84\x03aH\rWPPd\x01\0\0\x03\xD0\x19_\x91\x85\x08aE\xEEWPP\x90P_\x90_\x90V[d\x01\0\0\x03\xD0\x19\x80`\x01\x81\x80aFU\x81\x80\x80aFE\x9A\x81\x80\x8F\x80\t\x96\x87\x92\x81\x80\x80\x80\x80\x8F\x81\x81\x81\x92\t\x99\x87\t`\x04\t\x97\x80\t_\t\x92\x80\t`\x03\t\x08\x91\x81aF8\x81\x83\x80\x08\x82a3\x9DV[\x81\x85\x80\t\x08\x9D\x8E\x83a3\x9DV[\x90\x08\x90\t\x93\x80\t`\x08\t\x83a3\x9DV[\x90\x08\x96\t`\x02\t\x93\x91\x90[\x84\x15\x15\x85\x81aG\xFCW[P\x80aG\xF4W[\x15aG\x96W\x80\x94\x80`\x01d\x01\0\0\x03\xD0\x19\x84\x92[aF\xD9WPPPP\x80aF\xACWP\x90d\x01\0\0\x03\xD0\x19\x80\x92\x81\x80\x87\x80\t\x80\x92\t\x95\t\x90\t\x90V[\x80\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`$\x92R`\x12`\x04R\xFD[\x92\x97\x91\x92\x88\x15aGiW\x88\x81\x04\x91\x80\x94aG<Wd\x01\0\0\x03\xD0\x19\x90\x83\td\x01\0\0\x03\xD0\x19\x03d\x01\0\0\x03\xD0\x19\x81\x11a\n/Wd\x01\0\0\x03\xD0\x19\x90\x86\x94\x08\x93\x98\x80\x92\x81\x81\x02\x91\x81\x83\x04\x14\x90\x15\x17\x15a\n/WaG4\x91a3\x9DV[\x92\x90\x83aF\x85V[`$\x86\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x12`\x04R\xFD[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x12`\x04R`$_\xFD[`d`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x0E`$\x82\x01R\x7FInvalid number\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R\xFD[P`\x01aFqV[d\x01\0\0\x03\xD0\x19\x91P\x14\x15_aFjV[d\x01\0\0\x03\xD0\x19\x92\x91\x95aH \x94aJ\xA7V[\x93\x90\x91\x90aF`V[_\x90` \x92`@Q\x90\x84\x82\x01\x92\x83R`@\x82\x01R`@\x81RaHL``\x82a4HV[`@Q\x91\x82\x91Q\x80\x91\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xA9W_Q\x90V[\x80Q``\x92\x91_\x91[\x80\x83\x10aH\x81WPPPV[\x90\x91\x93aH\xC8c\xFF\xFF\xFF\xFF` aH\x98\x88\x87a7{V[Q\x01QQ`\x02\x1C\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x90` aH\xD5\x87\x86a7{V[Q\x01QaH\xE2\x87\x86a7{V[QQ`\x02\x81\x10\x15aI\xB3W`\x04` \x93aI\xAA\x93\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x86\x80`\x01\x99aII\x87\x98b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x94\x84`@Q\x9B\x88\x8D\x99Q\x91\x82\x91\x01\x86\x8B\x01^\x88\x01\x92`\xE0\x1B\x16\x83\x83\x01R\x80Q\x92\x83\x91\x01`$\x83\x01^\x01\x01\x91`\xE0\x1B\x16\x83\x82\x01R\x03\x01\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE4\x81\x01\x84R\x01\x82a4HV[\x94\x01\x91\x90aHuV[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`!`\x04R`$_\xFD[\x90`\x1F\x19`\x1F` \x80\x94\x80Q\x91\x82\x91\x82\x87R\x01\x86\x86\x01^_\x85\x82\x86\x01\x01R\x01\x16\x01\x01\x90V[\x90\x91aJ\x1Ca8\xD2\x93`@\x84R`@\x84\x01\x90aI\xE0V[\x91` \x81\x84\x03\x91\x01RaI\xE0V[`\x02Th\x01\0\0\0\0\0\0\0\0\x81\x10\x15a3\xC6W\x80`\x01aJP\x92\x01`\x02U`\x02a6]V[\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x93\x92T\x91`\x03\x1B\x92\x83\x1B\x92\x1B\x19\x16\x17\x90UV[\x80Th\x01\0\0\0\0\0\0\0\0\x81\x10\x15a3\xC6WaJP\x91`\x01\x82\x01\x81Ua6]V[\x94\x92\x91\x85\x15\x80aL\x9AW[aL\x8EW\x80\x15\x80aL\x86W[aL|W`@Q`\x80\x91aJ\xD2\x83\x83a4HV[\x826\x837\x86\x15aGiW\x86\x94\x85\x80\x92\x81\x80`\x01\x80\t\x80\x87R\x97\x81\x89`\x01\t\x9C` \x88\x01\x9D\x8ER\x82`@\x89\x01\x9D\x8E\x8C\x81RQ`\x01\t\x91``\x8A\x01\x92\x83R`@Q\x9E\x8FaK\x1C\x90a3\xF3V[Q\x90\t\x8DRQ\x90\t\x94` \x8B\x01\x95\x86RQ\x90\t\x98`@\x89\x01\x99\x8ARQ\x90\t``\x87\x01\x90\x81R\x86Q\x88Q\x14\x80\x15\x90aLpW[\x15aL\x12W\x84\x92\x83\x80\x80\x93\x81`@Q\x9C\x85aKj\x8F\x97\x88a4HV[6\x877Q\x8CQaKz\x90\x83a3\x9DV[\x90\x08\x84RQ\x85QaK\x8B\x90\x83a3\x9DV[\x90\x08\x98` \x83\x01\x99\x8AR\x81\x80\x8B\x81\x80\x80\x80\x89Q\x8AQ\x90\t\x93`@\x8A\x01\x94\x85R\x81\x85Q\x8BQ\x90\t``\x90\x9A\x01\x99\x8ARQ\x80\t\x88QaK\xC8\x90\x83a3\x9DV[\x90\x08\x81\x80\x87Q\x85Q\x90\t`\x02\taK\xDF\x90\x83a3\x9DV[\x90\x08\x9CQ\x93Q\x90Q\x90\taK\xF3\x8C\x83a3\x9DV[\x90\x08\x90\t\x92Q\x90Q\x90\taL\x07\x90\x83a3\x9DV[\x90\x08\x94Q\t\x91\x92\x91\x90V[`d`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x1E`$\x82\x01R\x7FUse jacDouble function instead\0\0`D\x82\x01R\xFD[P\x81Q\x81Q\x14\x15aKNV[P\x92P`\x01\x91\x90PV[P\x82\x15aJ\xBEV[\x94P\x90\x92P`\x01\x91\x90PV[P\x81\x15aJ\xB2V[\x80_R`\x05` R`@_ T\x15_\x14aL\xD6WaL\xC1\x81`\x04aJ\x85V[`\x04T\x90_R`\x05` R`@_ U`\x01\x90V[P_\x90V[\x80_R`\x07` R`@_ T\x15_\x14aL\xD6WaL\xFA\x81`\x06aJ\x85V[`\x06T\x90_R`\x07` R`@_ U`\x01\x90V[`\x04\x11\x15aI\xB3WV[\x81Q\x91\x90`A\x83\x03aMIWaMB\x92P` \x82\x01Q\x90```@\x84\x01Q\x93\x01Q_\x1A\x90aN\x1AV[\x91\x92\x90\x91\x90V[PP_\x91`\x02\x91\x90V[aM\\\x81aM\x0FV[\x80aMeWPPV[aMn\x81aM\x0FV[`\x01\x81\x03aM\x9EW\x7F\xF6E\xEE\xDF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04_\xFD[aM\xA7\x81aM\x0FV[`\x02\x81\x03aM\xDBWP\x7F\xFC\xE6\x98\xF7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[`\x03\x90aM\xE7\x81aM\x0FV[\x14aM\xEFWPV[\x7F\xD7\x8B\xCE\x0C\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[\x91\x90\x7F\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF]WnsW\xA4P\x1D\xDF\xE9/Fh\x1B \xA0\x84\x11aN\x9EW\x91` \x93`\x80\x92`\xFF_\x95`@Q\x94\x85R\x16\x86\x84\x01R`@\x83\x01R``\x82\x01R\x82\x80R`\x01Z\xFA\x15a\x02\xA9W_Qs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x15aN\x94W\x90_\x90_\x90V[P_\x90`\x01\x90_\x90V[PPP_\x91`\x03\x91\x90V\xFC\xED\xD3u\x89\x8C\0\xDER\xE8\xF1;\x0B\x8E2\xAD\x9C\x15w\xFE3;\x1D\x8F\x9C\x93*\xE1\xBC\xA6\xDA\xC3\xCC\x1D/\x83\x84E\xDBz\xECC\x1D\xF9\xEE\x8A\x87\x1F@\xE7\xAA^\x06O\xC0Vc>\xF8\xC6\x0F\xAB{\x06",
    );
    /// The runtime bytecode of the contract, as deployed on the network.
    ///
    /// ```text
    ///0x6080806040526004361015610012575f80fd5b5f3560e01c9081630d8e6e2c146133655750806331ee62421461334757806340f34d421461332a57806359ba92581461330d5780635b666b1e146132bd5780635c975abb1461329957806363a599a414613208578063715018a61461318c57806382d32ad814611d675780638da5cb5b14611d355780639ad91d4c14611cb8578063a06056f714611c98578063bdeb442d14611c41578063c1b0bed714611c15578063c44956d114611bf8578063c879dbe414611bcc578063e33845cf14611b70578063ed3cf91f146103d5578063f2fde38b14610304578063fddd48371461012a5763fe18ab9114610103575f80fd5b34610126575f600319360112610126576020600160ff600254161b604051908152f35b5f80fd5b34610126575f600319360112610126576040517f3cadf4490000000000000000000000000000000000000000000000000000000081527fffffffff000000000000000000000000000000000000000000000000000000007f000000000000000000000000000000000000000000000000000000000000000016600482015260208160248173ffffffffffffffffffffffffffffffffffffffff7f0000000000000000000000000000000000000000000000000000000000000000165afa9081156102a9575f916102b4575b50602073ffffffffffffffffffffffffffffffffffffffff916004604051809481937f5c975abb000000000000000000000000000000000000000000000000000000008352165afa9081156102a9575f9161026e575b508015610260575b6020906040519015158152f35b505f5460a01c60ff16610253565b90506020813d6020116102a1575b8161028960209383613448565b8101031261012657518015158103610126578161024b565b3d915061027c565b6040513d5f823e3d90fd5b90506020813d6020116102fc575b816102cf60209383613448565b81010312610126575173ffffffffffffffffffffffffffffffffffffffff811681036101265760206101f5565b3d91506102c2565b346101265760206003193601126101265760043573ffffffffffffffffffffffffffffffffffffffff81168091036101265761033e61346b565b80156103a95773ffffffffffffffffffffffffffffffffffffffff5f54827fffffffffffffffffffffffff00000000000000000000000000000000000000008216175f55167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e05f80a3005b7f1e4fbdf7000000000000000000000000000000000000000000000000000000005f525f60045260245ffd5b346101265760206003193601126101265767ffffffffffffffff6004351161012657606060031960043536030112610126577f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005c611b485760017f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005d6104596134b7565b61046161368a565b505f6104716004803501806134ed565b5f91505b808210611ab957826104916044600435016004356004016135c1565b9050151561049e826136f9565b916104a8816136f9565b916104b1613672565b506040516104be816133aa565b5f80825260208201528115611ab2578260011c925b601f196104f86104e2866136e1565b956104f06040519788613448565b8087526136e1565b015f5b818110611a575750508215611a4f57935b601f1961053161051b876136e1565b966105296040519889613448565b8088526136e1565b015f5b818110611a385750506040519561054a8761342b565b865260208601525f604086015260608501525f60808501525f60a085015260c084015260e083015261010082015261058c6004356004016004356004016134ed565b90505f5b818110610c1a5782608081015161061b575b6105e5816105f360207f10dd528db2c49add6545679b976df90d24c035d6a75b17f41b700e8c18ca53649451920151604051938493604085526040850190613612565b908382036020850152613612565b0390a15f7f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005d005b61067161067a6106356024600435016004356004016135c1565b919061064b6044600435016004356004016135c1565b94909361066b60608801519388516020815160051b910120923691613950565b90614d19565b90939193614d53565b60208151910151905f5260205273ffffffffffffffffffffffffffffffffffffffff8060405f2016911690808203610bec57505060c0830151610752575b50506040810151906106c982614ca2565b15610726576105e5907f0a2dc548ed950accb40d5d78541f3954c5e182a8ecf19e581a4f2263f61f59d260207f10dd528db2c49add6545679b976df90d24c035d6a75b17f41b700e8c18ca536494604051908152a19150506105a2565b507fdb788c2b000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b81600411610126576107867fffffffff000000000000000000000000000000000000000000000000000000008235166141f8565b602083015160e084015161010085015190604051926107a48461340f565b835260208301908082526040840192835251926020936040516107c78682613448565b5f8152926040516107d88782613448565b5f8152945f915b87848410610a5c575050505061081d63ffffffff821662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b938160011b9180830460021490151715610a2f5760248661086863ffffffff6028951662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b9451947fffffffff00000000000000000000000000000000000000000000000000000000826040519882828b019b60e01b168b52805191829101868b015e8801917f919e13001cd3319be5a5a7cb189203be083674acb3fff23d05aae9c3ed86314d8584015260e01b1693846044830152805192839101604883015e010190602482015201848251919201905f5b86828210610a1b575050505090610918815f949303601f198101835282613448565b604051918291518091835e8101838152039060025afa156102a9575f519160a084015115610947575b506106b8565b73ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016803b15610126575f926109c992604051958694859384937fab750e75000000000000000000000000000000000000000000000000000000008552606060048601526064850191613844565b907f213b3f40d7c113c1a012072fcd791fa44bf5166a2300121630bd3228e2b008276024840152604483015203915afa80156102a957610a0b575b8080610941565b5f610a1591613448565b81610a04565b8351855293840193909201916001016108f6565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52601160045260245ffd5b9091929695610aaf908280610a7b610a758c885161377b565b51614278565b6040519584879551918291018487015e8401908282015f8152815193849201905e01015f815203601f198101835282613448565b9482518760011b9088820460021489151715610a2f57610ad282610ad89261377b565b516142d6565b84519060018301809311610a2f5760019360048c8193610aff610ad28398610be39861377b565b7fffffffff000000000000000000000000000000000000000000000000000000008380610b5863ffffffff865160021c1662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b610b8e63ffffffff865160021c1662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b95846040519d8b8f82819e519384930191015e8b019260e01b1683830152805192839101602483015e01019260e01b1684830152805192839101600883015e01015f838201520301601f198101835282613448565b960191906107df565b7fe6d44b4c000000000000000000000000000000000000000000000000000000005f5260045260245260445ffd5b610c3281610c2c6004803501806134ed565b90613541565b610c3f60208201826134ed565b80915060011b81810460021482151715610a2f57610c5c906136f9565b905f5b8181106119e1575050600160ff82516fffffffffffffffffffffffffffffffff811160071b67ffffffffffffffff82821c1160061b1763ffffffff82821c1160051b1761ffff82821c1160041b178282821c1160031b17600f82821c1160021b177d01010202020203030303030303030000000000000000000000000000000082821c1a179083821b1001161b610cf5816136f9565b915f5b8281106119865750505b600181116119075750610d149061376e565b5190610d2360208201826134ed565b90505f5b818110610d73575050604060019392610d61837f1cc9a0755dd734c1ebfe98b68ece200037e363eb366d0dee04e420e2f23cc010946134ed565b8351928352602083015250a101610590565b610d8a81610d8460208601866134ed565b90613581565b96610d9361368a565b5060208801906060890135805f52600560205260405f2054156118dc575060c081015186901561176457610e04610e0f93610def60e0850151608086015160011c90610ddf368561379c565b610de9838361377b565b5261377b565b505b610dfb88806134ed565b909135916138d5565b60408b013590613a95565b96610e28610e1d85806134ed565b6080840135916138d5565b60a0820135610e3561368a565b5080602083013503611730575060808136031261012657604051610e58816133f3565b8135815260208201356020820152604082013567ffffffffffffffff8111610126578201906080823603126101265760405191610e94836133f3565b803567ffffffffffffffff811161012657610eb290369083016139a1565b8352602081013567ffffffffffffffff811161012657610ed590369083016139a1565b6020840152604081013567ffffffffffffffff811161012657610efb90369083016139a1565b604084015260608101359067ffffffffffffffff821161012657610f21913691016139a1565b6060830152604081019182526060830190813567ffffffffffffffff811161012657610f509036908601613986565b6060820152610f5d61372a565b5051915160405192610f6e846133f3565b83525f602084015260408301899052606083015260c08b0151156116015750610fa7906101008b015160808c015191610de9838361377b565b505b610fc3610fb96040830183613888565b60408101906134ed565b90505f5b818110611416575050885160808a0190610fe583359183519061377b565b5261100860208b015191805190610ffb82613a68565b905260208401359261377b565b5260ff6002541660015461101b81613a68565b600155908235915f5b828110611370575050600154600160ff600254161b1461132f575b5060408a015261105b6110556040830183613888565b806134ed565b5f5b8181106112cf575050506110816110776040830183613888565b60208101906134ed565b5f5b81811061126f5750505061109d610fb96040830183613888565b5f5b8181106111fd575050506110c36110b96040830183613888565b60608101906134ed565b90915f5b8281106111815750505050606088018051604051926110e5846133aa565b60c0810135845260e060208501910135815260405193611104856133aa565b5f85525f602086015261111a8151835190614563565b15611149579161113b916001969594936020835193015190519151926145c5565b602084015282525201610d27565b604491604051917fb8a0e8a1000000000000000000000000000000000000000000000000000000008352516004830152516024820152fd5b61118c818486613541565b359060028210156101265760018092146111a7575b016110c7565b6111f57fa494dac4b7184843583f972e06783e2c3bb47f4f0137b8df52a860df07219f8c6111e36111d984888a613541565b60208101906135c1565b6040518735949092839290878461454c565b0390a26111a1565b611208818385613541565b35906002821015610126576001809214611223575b0161109f565b6112677f9c61b290f631097f56273cf4daf40df1ff9ccc33f101d464837da1f5ae18bd596112556111d9848789613541565b6040518935949092839290878461454c565b0390a261121d565b61127a818385613541565b35906002821015610126576001809214611295575b01611083565b6112c77f48243873b4752ddcb45e0d7b11c4c266583e5e099a0b798fdd9c1af7d49324f36112556111d9848789613541565b0390a261128f565b6112da818385613541565b359060028210156101265760018092146112f5575b0161105d565b6113277f3a134d01c07803003c63301717ddc4612e6c47ae408eeea3222cded532d02ae66112556111d9848789613541565b0390a26112ef565b9061136a9161133d82614a2a565b60035f527fc2575a0e9e593c00f959f8c92f12db2869c3395a3b0502d05e2516446f71f85b015490614829565b8a61103f565b90926001908185166113de577f405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace830181905560035f527fc2575a0e9e593c00f959f8c92f12db2869c3395a3b0502d05e2516446f71f85b8301546113d391614829565b935b811c9101611024565b60025f527f405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace8301546114109190614829565b936113d5565b61142d6111d982610c2c610fb96040880188613888565b81016060828203126101265781359173ffffffffffffffffffffffffffffffffffffffff831680930361012657602081013567ffffffffffffffff8111610126578261147a918301613986565b91604082013567ffffffffffffffff8111610126576114999201613986565b90604051917f33a8920300000000000000000000000000000000000000000000000000000000835260208701356004840152604060248401525f83806114e260448201866149e0565b038183885af19283156102a9575f93611585575b5082516020840120815160208301200361154a575060019392917fcddb327adb31fe5437df2a8c68301bb13a6baae432a804838caaf682506aadf19161154160405192839283614a05565b0390a201610fc7565b90506115816040519283927fc504fada00000000000000000000000000000000000000000000000000000000845260048401614a05565b0390fd5b9092503d805f833e6115978183613448565b8101906020818303126101265780519067ffffffffffffffff8211610126570181601f82011215610126578051906115ce82613934565b926115dc6040519485613448565b8284526020838301011161012657815f9260208093018386015e83010152918f6114f6565b61160b81846135c1565b600411610126577fffffffff0000000000000000000000000000000000000000000000000000000061163e9135166141f8565b60a08b015115611650575b5050610fa9565b6116a19060205f8161169973ffffffffffffffffffffffffffffffffffffffff7f00000000000000000000000000000000000000000000000000000000000000001694886135c1565b9590966142d6565b604051918183925191829101835e8101838152039060025afa156102a9575f5190803b156101265761170b935f93604051958694859384937fab750e7500000000000000000000000000000000000000000000000000000000855260208b01359160048601613864565b03915afa80156102a957611720575b80611649565b5f61172a91613448565b8961171a565b602092507f18f639d8000000000000000000000000000000000000000000000000000000005f52600452013560245260445ffd5b5061176f89806135c1565b600411610126577fffffffff000000000000000000000000000000000000000000000000000000006117a29135166141f8565b8560a0820151156117ba575b610e04610e0f93610df1565b5073ffffffffffffffffffffffffffffffffffffffff7f0000000000000000000000000000000000000000000000000000000000000000166117fc8a806135c1565b60205f8161181261180d368a61379c565b614278565b604051918183925191829101835e8101838152039060025afa156102a9575f5192803b15610126575f9261187e92604051958694859384937fab750e75000000000000000000000000000000000000000000000000000000008552606060048601526064850191613844565b907f919e13001cd3319be5a5a7cb189203be083674acb3fff23d05aae9c3ed86314d6024840152604483015203915afa80156102a957610e0f938892610e04926118cc575b509350506117ae565b5f6118d691613448565b8c6118c3565b7ff9849ea3000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b60011c5f5b8181106119195750610d02565b8060011b907f7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff81168103610a2f57611951828561377b565b519160018101809111610a2f5760019261196e611975928761377b565b5190614829565b61197f828661377b565b520161190c565b600190825181105f146119b05761199d818461377b565b516119a8828761377b565b525b01610cf8565b7fcc1d2f838445db7aec431df9ee8a871f40e7aa5e064fc056633ef8c60fab7b066119db828761377b565b526119aa565b6119f281610d8460208701876134ed565b908060011b81810460021482151715610a2f576020830135611a14828761377b565b5260018101809111610a2f57611a3160806001940135918661377b565b5201610c5f565b602090611a4361372a565b82828a01015201610534565b505f9361050c565b602090604051611a66816133f3565b604051611a728161340f565b5f81525f848201525f60408201528152604051611a8e816133aa565b5f81525f84820152838201525f60408201525f6060820152828289010152016104fb565b5f926104d3565b9091611acd83610c2c6004803501806134ed565b90611ae7611ade60208401846134ed565b938091506134ed565b9280915060011b9080820460021490151715610a2f57808303611b195750600191611b119161378f565b920190610475565b827fd3bee78d000000000000000000000000000000000000000000000000000000005f5260045260245260445ffd5b7f3ee5aeb5000000000000000000000000000000000000000000000000000000005f5260045ffd5b34610126575f6003193601126101265760206040517fffffffff000000000000000000000000000000000000000000000000000000007f0000000000000000000000000000000000000000000000000000000000000000168152f35b34610126576020600319360112610126576004355f526005602052602060405f20541515604051908152f35b34610126575f600319360112610126576020600154604051908152f35b34610126576020600319360112610126576004355f526007602052602060405f20541515604051908152f35b34610126575f600319360112610126576004547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8101908111610a2f57611c89602091613645565b90549060031b1c604051908152f35b34610126575f60031936011261012657602060ff60025416604051908152f35b3461012657602060031936011261012657600435600654811015611d085760065f527ff652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f0154604051908152602090f35b7f4e487b71000000000000000000000000000000000000000000000000000000005f52603260045260245ffd5b34610126575f60031936011261012657602073ffffffffffffffffffffffffffffffffffffffff5f5416604051908152f35b346101265760406003193601126101265767ffffffffffffffff600435116101265760606003196004353603011261012657602435801515809103610126575a907f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005c611b485760017f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005d611dfa6134b7565b611e0261368a565b505f90611e136004803501806134ed565b5f91505b808210613135575050611e346044600435016004356004016135c1565b9050151591611e42816136f9565b92611e4c826136f9565b92611e55613672565b50604051611e62816133aa565b5f8082526020820152821561312e578360011c935b601f19611e8661051b876136e1565b015f5b8181106130d357505083156130cb57945b601f19611ebf611ea9886136e1565b97611eb7604051998a613448565b8089526136e1565b015f5b8181106130b457505060405196611ed88861342b565b875260208701525f604087015260608601525f608086015260a085015260c084015260e083015261010082015290611f1a6004356004016004356004016134ed565b90505f5b8181106124445750506080820151611fcf575b7f10dd528db2c49add6545679b976df90d24c035d6a75b17f41b700e8c18ca53646105e583611f776020611fa49651920151604051938493604085526040850190613612565b0390a15f7f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005d5a9061339d565b7f6f149831000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b61067161201f611fe96024600435016004356004016135c1565b9190611fff6044600435016004356004016135c1565b94909361066b60608901519389516020815160051b910120923691613950565b60208151910151905f5260205273ffffffffffffffffffffffffffffffffffffffff8060405f2016911690808203610bec57505060c08401516120fb575b505060408201519161206e83614ca2565b156120cf576105e57f10dd528db2c49add6545679b976df90d24c035d6a75b17f41b700e8c18ca5364917f0a2dc548ed950accb40d5d78541f3954c5e182a8ecf19e581a4f2263f61f59d26020611fa496604051908152a193505050611f31565b827fdb788c2b000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b816004116101265761212f7fffffffff000000000000000000000000000000000000000000000000000000008235166141f8565b602084015160e0850151610100860151906040519261214d8461340f565b835260208301908082526040840192835251926020936040516121708682613448565b5f8152926040516121818782613448565b5f8152945f915b878484106123d857505050506121c663ffffffff821662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b938160011b9180830460021490151715610a2f5760248661221163ffffffff6028951662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b9451947fffffffff00000000000000000000000000000000000000000000000000000000826040519882828b019b60e01b168b52805191829101868b015e8801917f919e13001cd3319be5a5a7cb189203be083674acb3fff23d05aae9c3ed86314d8584015260e01b1693846044830152805192839101604883015e010190602482015201848251919201905f5b868282106123c45750505050906122c1815f949303601f198101835282613448565b604051918291518091835e8101838152039060025afa156102a9575f519160a0850151156122f0575b5061205d565b73ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016803b15610126575f9261237292604051958694859384937fab750e75000000000000000000000000000000000000000000000000000000008552606060048601526064850191613844565b907f213b3f40d7c113c1a012072fcd791fa44bf5166a2300121630bd3228e2b008276024840152604483015203915afa80156102a9576123b4575b80806122ea565b5f6123be91613448565b826123ad565b83518552938401939092019160010161229f565b90919296956123f1908280610a7b610a758c885161377b565b9482518760011b9088820460021489151715610a2f57610ad2826124149261377b565b84519060018301809311610a2f5760019360048c8193610aff610ad2839861243b9861377b565b96019190612188565b61245681610c2c6004803501806134ed565b61246360208201826134ed565b80915060011b81810460021482151715610a2f57612480906136f9565b905f5b81811061305d575050600160ff82516fffffffffffffffffffffffffffffffff811160071b67ffffffffffffffff82821c1160061b1763ffffffff82821c1160051b1761ffff82821c1160041b178282821c1160031b17600f82821c1160021b177d01010202020203030303030303030000000000000000000000000000000082821c1a179083821b1001161b612519816136f9565b915f5b8281106130025750505b60018111612f8a57506125389061376e565b519061254760208201826134ed565b90505f5b818110612597575050604060019392612585837f1cc9a0755dd734c1ebfe98b68ece200037e363eb366d0dee04e420e2f23cc010946134ed565b8351928352602083015250a101611f1e565b6125a881610d8460208601866134ed565b976125b161368a565b50602089019060608a0135805f52600560205260405f2054156118dc575060c0810151869015612e17576125fd61260893610def60e0850151608086015160011c90610ddf368561379c565b60408c013590613a95565b97612616610e1d85806134ed565b60a082013561262361368a565b5080602083013503611730575060808136031261012657604051612646816133f3565b8135815260208201356020820152604082013567ffffffffffffffff8111610126578201906080823603126101265760405191612682836133f3565b803567ffffffffffffffff8111610126576126a090369083016139a1565b8352602081013567ffffffffffffffff8111610126576126c390369083016139a1565b6020840152604081013567ffffffffffffffff8111610126576126e990369083016139a1565b604084015260608101359067ffffffffffffffff82116101265761270f913691016139a1565b6060830152604081019182526060830190813567ffffffffffffffff81116101265761273e9036908601613986565b606082015261274b61372a565b505191516040519261275c846133f3565b83525f602084015260408301899052606083015260c08c015115612cf05750612795906101008c015160808d015191610de9838361377b565b505b6127a7610fb96040830183613888565b90505f5b818110612b40575050895160808b01906127c983359183519061377b565b526127df60208c015191805190610ffb82613a68565b5260ff600254166001546127f281613a68565b600155908235915f5b828110612a9a575050600154600160ff600254161b14612a86575b5060408b015261282c6110556040830183613888565b5f5b818110612a26575050506128486110776040830183613888565b5f5b8181106129c657505050612864610fb96040830183613888565b5f5b818110612966575050506128806110b96040830183613888565b90915f5b8281106129065750505050606089018051604051926128a2846133aa565b60c0810135845260e0602085019101358152604051936128c1856133aa565b5f85525f60208601526128d78151835190614563565b1561114957916128f8916001969594936020835193015190519151926145c5565b60208401528252520161254b565b612911818486613541565b3590600282101561012657600180921461292c575b01612884565b61295e7fa494dac4b7184843583f972e06783e2c3bb47f4f0137b8df52a860df07219f8c6111e36111d984888a613541565b0390a2612926565b612971818385613541565b3590600282101561012657600180921461298c575b01612866565b6129be7f9c61b290f631097f56273cf4daf40df1ff9ccc33f101d464837da1f5ae18bd596112556111d9848789613541565b0390a2612986565b6129d1818385613541565b359060028210156101265760018092146129ec575b0161284a565b612a1e7f48243873b4752ddcb45e0d7b11c4c266583e5e099a0b798fdd9c1af7d49324f36112556111d9848789613541565b0390a26129e6565b612a31818385613541565b35906002821015610126576001809214612a4c575b0161282e565b612a7e7f3a134d01c07803003c63301717ddc4612e6c47ae408eeea3222cded532d02ae66112556111d9848789613541565b0390a2612a46565b90612a949161133d82614a2a565b8b612816565b9092600190818516612b08577f405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace830181905560035f527fc2575a0e9e593c00f959f8c92f12db2869c3395a3b0502d05e2516446f71f85b830154612afd91614829565b935b811c91016127fb565b60025f527f405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace830154612b3a9190614829565b93612aff565b612b576111d982610c2c610fb96040880188613888565b81016060828203126101265781359173ffffffffffffffffffffffffffffffffffffffff831680930361012657602081013567ffffffffffffffff81116101265782612ba4918301613986565b91604082013567ffffffffffffffff811161012657612bc39201613986565b90604051917f33a8920300000000000000000000000000000000000000000000000000000000835260208701356004840152604060248401525f8380612c0c60448201866149e0565b038183885af19283156102a9575f93612c74575b5082516020840120815160208301200361154a575060019392917fcddb327adb31fe5437df2a8c68301bb13a6baae432a804838caaf682506aadf191612c6b60405192839283614a05565b0390a2016127ab565b9092503d805f833e612c868183613448565b8101906020818303126101265780519067ffffffffffffffff8211610126570181601f8201121561012657805190612cbd82613934565b92612ccb6040519485613448565b8284526020838301011161012657815f9260208093018386015e83010152915f612c20565b612cfa81846135c1565b600411610126577fffffffff00000000000000000000000000000000000000000000000000000000612d2d9135166141f8565b60a08c015115612d3f575b5050612797565b612d889060205f8161169973ffffffffffffffffffffffffffffffffffffffff7f00000000000000000000000000000000000000000000000000000000000000001694886135c1565b604051918183925191829101835e8101838152039060025afa156102a9575f5190803b1561012657612df2935f93604051958694859384937fab750e7500000000000000000000000000000000000000000000000000000000855260208b01359160048601613864565b03915afa80156102a957612e07575b80612d38565b5f612e1191613448565b8a612e01565b50612e228a806135c1565b600411610126577fffffffff00000000000000000000000000000000000000000000000000000000612e559135166141f8565b8560a082015115612e6d575b6125fd61260893610df1565b5073ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016612eaf8b806135c1565b60205f81612ec061180d368a61379c565b604051918183925191829101835e8101838152039060025afa156102a9575f5192803b15610126575f92612f2c92604051958694859384937fab750e75000000000000000000000000000000000000000000000000000000008552606060048601526064850191613844565b907f919e13001cd3319be5a5a7cb189203be083674acb3fff23d05aae9c3ed86314d6024840152604483015203915afa80156102a9576126089388926125fd92612f7a575b50935050612e61565b5f612f8491613448565b8d612f71565b60011c5f5b818110612f9c5750612526565b8060011b907f7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff81168103610a2f57612fd4828561377b565b519160018101809111610a2f5760019261196e612ff1928761377b565b612ffb828661377b565b5201612f8f565b600190825181105f1461302c57613019818461377b565b51613024828761377b565b525b0161251c565b7fcc1d2f838445db7aec431df9ee8a871f40e7aa5e064fc056633ef8c60fab7b06613057828761377b565b52613026565b61306e81610d8460208701876134ed565b908060011b81810460021482151715610a2f576020830135613090828761377b565b5260018101809111610a2f576130ad60806001940135918661377b565b5201612483565b6020906130bf61372a565b82828b01015201611ec2565b505f94611e9a565b6020906040516130e2816133f3565b6040516130ee8161340f565b5f81525f848201525f6040820152815260405161310a816133aa565b5f81525f84820152838201525f60408201525f606082015282828a01015201611e89565b5f93611e77565b909261314984610c2c6004803501806134ed565b9061315a611ade60208401846134ed565b9280915060011b9080820460021490151715610a2f57808303611b1957506001916131849161378f565b930190611e17565b34610126575f600319360112610126576131a461346b565b5f73ffffffffffffffffffffffffffffffffffffffff81547fffffffffffffffffffffffff000000000000000000000000000000000000000081168355167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e08280a3005b34610126575f6003193601126101265761322061346b565b6132286134b7565b6132306134b7565b740100000000000000000000000000000000000000007fffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff5f5416175f557f62e78cea01bee320cd4e420270b5ea74000d11b0c9f74754ebdbfc544b05a2586020604051338152a1005b34610126575f60031936011261012657602060ff5f5460a01c166040519015158152f35b34610126575f60031936011261012657602060405173ffffffffffffffffffffffffffffffffffffffff7f0000000000000000000000000000000000000000000000000000000000000000168152f35b34610126575f600319360112610126576020600454604051908152f35b34610126575f600319360112610126576020600654604051908152f35b34610126576020600319360112610126576020611c89600435613645565b34610126575f60031936011261012657807f312e312e3000000000000000000000000000000000000000000000000000000060209252f35b91908203918211610a2f57565b6040810190811067ffffffffffffffff8211176133c657604052565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52604160045260245ffd5b6080810190811067ffffffffffffffff8211176133c657604052565b6060810190811067ffffffffffffffff8211176133c657604052565b610120810190811067ffffffffffffffff8211176133c657604052565b90601f601f19910116810190811067ffffffffffffffff8211176133c657604052565b73ffffffffffffffffffffffffffffffffffffffff5f5416330361348b57565b7f118cdaa7000000000000000000000000000000000000000000000000000000005f523360045260245ffd5b60ff5f5460a01c166134c557565b7fd93c0665000000000000000000000000000000000000000000000000000000005f5260045ffd5b9035907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe181360301821215610126570180359067ffffffffffffffff821161012657602001918160051b3603831361012657565b9190811015611d085760051b810135907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc181360301821215610126570190565b9190811015611d085760051b810135907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0181360301821215610126570190565b9035907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe181360301821215610126570180359067ffffffffffffffff82116101265760200191813603831361012657565b90602080835192838152019201905f5b81811061362f5750505090565b8251845260209384019390920191600101613622565b600454811015611d085760045f5260205f2001905f90565b8054821015611d08575f5260205f2001905f90565b6040519061367f826133aa565b5f6020838281520152565b604051906136978261342b565b6060610100838281528260208201525f60408201526040516136b8816133aa565b5f81525f6020820152838201525f60808201525f60a08201525f60c08201528260e08201520152565b67ffffffffffffffff81116133c65760051b60200190565b90613703826136e1565b6137106040519182613448565b828152601f1961372082946136e1565b0190602036910137565b60405190613737826133f3565b815f81525f60208201525f6040820152606060405191613756836133f3565b81835281602084015281604084015281808401520152565b805115611d085760200190565b8051821015611d085760209160051b010190565b91908201809211610a2f57565b809291039160e0831261012657604051906137b6826133f3565b819360608112610126577fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa060409182516137ef8161340f565b84358152602085013560208201528385013584820152855201126101265760c060609160405161381e816133aa565b83820135815260808201356020820152602085015260a081013560408501520135910152565b601f8260209493601f1993818652868601375f8582860101520116010190565b9061387e9060409396959496606084526060840191613844565b9460208201520152565b9035907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8181360301821215610126570190565b90821015611d08576138d29160051b810190613888565b90565b909291925f5b81811061390e57847f89211474000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b8461391a8284866138bb565b3514613928576001016138db565b916138d29394506138bb565b67ffffffffffffffff81116133c657601f01601f191660200190565b92919261395c82613934565b9161396a6040519384613448565b829481845281830111610126578281602093845f960137010152565b9080601f83011215610126578160206138d293359101613950565b9080601f83011215610126578135916139b9836136e1565b926139c76040519485613448565b80845260208085019160051b830101918383116101265760208101915b8383106139f357505050505090565b823567ffffffffffffffff8111610126578201906040601f1983880301126101265760405190613a22826133aa565b6020830135600281101561012657825260408301359167ffffffffffffffff831161012657613a5988602080969581960101613986565b838201528152019201916139e4565b7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8114610a2f5760010190565b93929091613aa161368a565b5081945f936020820135908082036141ca57506080823603126101265760405193613acb856133f3565b8235948581528260208201526040840194853567ffffffffffffffff8111610126578501906080823603126101265760405191613b07836133f3565b803567ffffffffffffffff811161012657613b2590369083016139a1565b8352602081013567ffffffffffffffff811161012657613b4890369083016139a1565b6020840152604081013567ffffffffffffffff811161012657613b6e90369083016139a1565b604084015260608101359067ffffffffffffffff821161012657613b94913691016139a1565b6060830152604083019182526060860192833567ffffffffffffffff811161012657613bc39036908901613986565b6060820152613bd061372a565b505191519060405192613be2846133f3565b8352600160208401526040830152606082015260c08301511561409b57613c1a9150610100830151608084015191610de9838361377b565b505b613c29610fb98585613888565b9050865b818110613ed0575050806020613c6692519187613c50608083019485519061377b565b520151815191613c5f83613a68565b905261377b565b52613c7083614cdb565b15613ea457613c826110558383613888565b855b818110613e3557505050613c9b6110778383613888565b855b818110613dc657505050613cb4610fb98383613888565b855b818110613d5357505050613ccd916110b991613888565b839291925b818110613ce0575050505050565b613ceb818386613541565b356002811015613d4f57906001809214613d06575b01613cd2565b837fa494dac4b7184843583f972e06783e2c3bb47f4f0137b8df52a860df07219f8c613d366111d984878a613541565b90613d47604051928392878461454c565b0390a2613d00565b8580fd5b613d5e818385613541565b356002811015613dc257906001809214613d79575b01613cb6565b867f9c61b290f631097f56273cf4daf40df1ff9ccc33f101d464837da1f5ae18bd59613da96111d9848789613541565b90613dba604051928392878461454c565b0390a2613d73565b8780fd5b613dd1818385613541565b356002811015613dc257906001809214613dec575b01613c9d565b867f48243873b4752ddcb45e0d7b11c4c266583e5e099a0b798fdd9c1af7d49324f3613e1c6111d9848789613541565b90613e2d604051928392878461454c565b0390a2613de6565b613e40818385613541565b356002811015613dc257906001809214613e5b575b01613c84565b867f3a134d01c07803003c63301717ddc4612e6c47ae408eeea3222cded532d02ae6613e8b6111d9848789613541565b90613e9c604051928392878461454c565b0390a2613e55565b602484847f39a940c5000000000000000000000000000000000000000000000000000000008252600452fd5b613ee46111d982610c2c610fb98a8a613888565b8101906060818303126140975780359173ffffffffffffffffffffffffffffffffffffffff831680930361409357602082013567ffffffffffffffff811161408f5781613f32918401613986565b9160408101359067ffffffffffffffff821161408057613f53929101613986565b90604051917f33a89203000000000000000000000000000000000000000000000000000000008352876004840152604060248401528b8380613f9860448201866149e0565b038183885af1928315614084578c93614000575b5082516020840120815160208301200361154a575060019392917fcddb327adb31fe5437df2a8c68301bb13a6baae432a804838caaf682506aadf191613ff760405192839283614a05565b0390a201613c2d565b9092503d808d833e6140128183613448565b8101906020818303126140805780519067ffffffffffffffff821161407c570181601f820112156140805780519061404982613934565b926140576040519485613448565b8284526020838301011161407c57818e9260208093018386015e83010152915f613fac565b8d80fd5b8c80fd5b6040513d8e823e3d90fd5b8b80fd5b8a80fd5b8980fd5b6140a582866135c1565b600411610126577fffffffff000000000000000000000000000000000000000000000000000000006140d89135166141f8565b60a0830151156140ea575b5050613c1c565b61413b9060205f8161413373ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016968a6135c1565b9590946142d6565b604051918183925191829101835e8101838152039060025afa156102a9575f5192803b15610126575f9286926141a0604051968795869485947fab750e7500000000000000000000000000000000000000000000000000000000865260048601613864565b03915afa80156102a9576141b5575b806140e3565b6141c29196505f90613448565b5f945f6141af565b7f18f639d8000000000000000000000000000000000000000000000000000000005f5260045260245260445ffd5b7fffffffff00000000000000000000000000000000000000000000000000000000807f00000000000000000000000000000000000000000000000000000000000000001691169080820361424a575050565b7f78a2221c000000000000000000000000000000000000000000000000000000005f5260045260245260445ffd5b80518051916040602083015192015160208201516020815191015191606060408501519401519460405196602088015260408701526060860152608085015260a084015260c083015260e082015260e081526138d261010082613448565b606081015181516020830151909190156145435760406301000000935b015190805190815163ffffffff1661432d9062ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b916143379061486c565b6020820151805163ffffffff166143709062ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b9061437a9061486c565b90604084015192835163ffffffff166143b59062ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b936143bf9061486c565b946060015195865163ffffffff166143f99062ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b966144039061486c565b976040519a8b9a60208c015260e01b7fffffffff000000000000000000000000000000000000000000000000000000001660408b015260448a015260e01b7fffffffff000000000000000000000000000000000000000000000000000000001660648901528051602081920160688a015e87019060e01b7fffffffff0000000000000000000000000000000000000000000000000000000016606882015281516020819301606c83015e016068019060e01b7fffffffff0000000000000000000000000000000000000000000000000000000016600482015281516020819301600883015e016004019060e01b7fffffffff0000000000000000000000000000000000000000000000000000000016600482015281516020819301600883015e01600401600481015f905203600401601f19810182526138d29082613448565b60405f936142f3565b6040906138d2949281528160208201520191613844565b801580156145b5575b80156145ad575b801561459d575b614597576401000003d01960078180938181800909089180091490565b50505f90565b506401000003d01982101561457a565b508115614573565b506401000003d01981101561456c565b90939290915f9080840361480d5750506401000003d0195f9185086145ee57505090505f905f90565b6401000003d01980600181806146558180806146459a81808f800996879281808080808f81818192099987096004099780095f09928009600309089181614638818380088261339d565b81858009089d8e8361339d565b900890099380096008098361339d565b900896096002099391905b84151585816147fc575b50806147f4575b156147965780948060016401000003d01984925b6146d95750505050806146ac5750906401000003d019809281808780098092099509900990565b807f4e487b7100000000000000000000000000000000000000000000000000000000602492526012600452fd5b9297919288156147695788810491809461473c576401000003d0199083096401000003d019036401000003d0198111610a2f576401000003d0199086940893988092818102918183041490151715610a2f576147349161339d565b929083614685565b6024867f4e487b710000000000000000000000000000000000000000000000000000000081526012600452fd5b7f4e487b71000000000000000000000000000000000000000000000000000000005f52601260045260245ffd5b60646040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152600e60248201527f496e76616c6964206e756d6265720000000000000000000000000000000000006044820152fd5b506001614671565b6401000003d019915014155f61466a565b6401000003d01992919561482094614aa7565b93909190614660565b5f906020926040519084820192835260408201526040815261484c606082613448565b604051918291518091835e8101838152039060025afa156102a9575f5190565b8051606092915f915b80831061488157505050565b9091936148c863ffffffff6020614898888761377b565b5101515160021c1662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b9060206148d5878661377b565b5101516148e2878661377b565b515160028110156149b35760046020936149aa937fffffffff000000000000000000000000000000000000000000000000000000008680600199614949879862ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b94846040519b888d995191829101868b015e88019260e01b1683830152805192839101602483015e01019160e01b168382015203017fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe4810184520182613448565b94019190614875565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52602160045260245ffd5b90601f19601f602080948051918291828752018686015e5f8582860101520116010190565b9091614a1c6138d2936040845260408401906149e0565b9160208184039101526149e0565b600254680100000000000000008110156133c657806001614a509201600255600261365d565b7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff829392549160031b92831b921b1916179055565b8054680100000000000000008110156133c657614a509160018201815561365d565b949291851580614c9a575b614c8e57801580614c86575b614c7c57604051608091614ad28383613448565b8236833786156147695786948580928180600180098087529781896001099c602088019d8e5282604089019d8e8c8152516001099160608a019283526040519e8f614b1c906133f3565b5190098d525190099460208b019586525190099860408901998a52519009606087019081528651885114801590614c70575b15614c1257849283808093816040519c85614b6a8f9788613448565b368737518c51614b7a908361339d565b90088452518551614b8b908361339d565b90089860208301998a5281808b8180808089518a5190099360408a019485528185518b5190096060909a01998a525180098851614bc8908361339d565b90088180875185519009600209614bdf908361339d565b90089c51935190519009614bf38c8361339d565b90089009925190519009614c07908361339d565b900894510991929190565b60646040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601e60248201527f557365206a6163446f75626c652066756e6374696f6e20696e737465616400006044820152fd5b50815181511415614b4e565b5092506001919050565b508215614abe565b94509092506001919050565b508115614ab2565b805f52600560205260405f2054155f14614cd657614cc1816004614a85565b600454905f52600560205260405f2055600190565b505f90565b805f52600760205260405f2054155f14614cd657614cfa816006614a85565b600654905f52600760205260405f2055600190565b600411156149b357565b8151919060418303614d4957614d429250602082015190606060408401519301515f1a90614e1a565b9192909190565b50505f9160029190565b614d5c81614d0f565b80614d65575050565b614d6e81614d0f565b60018103614d9e577ff645eedf000000000000000000000000000000000000000000000000000000005f5260045ffd5b614da781614d0f565b60028103614ddb57507ffce698f7000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b600390614de781614d0f565b14614def5750565b7fd78bce0c000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b91907f7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a08411614e9e579160209360809260ff5f9560405194855216868401526040830152606082015282805260015afa156102a9575f5173ffffffffffffffffffffffffffffffffffffffff811615614e9457905f905f90565b505f906001905f90565b5050505f916003919056
    /// ```
    #[rustfmt::skip]
    #[allow(clippy::all)]
    pub static DEPLOYED_BYTECODE: alloy_sol_types::private::Bytes = alloy_sol_types::private::Bytes::from_static(
        b"`\x80\x80`@R`\x046\x10\x15a\0\x12W_\x80\xFD[_5`\xE0\x1C\x90\x81c\r\x8En,\x14a3eWP\x80c1\xEEbB\x14a3GW\x80c@\xF3MB\x14a3*W\x80cY\xBA\x92X\x14a3\rW\x80c[fk\x1E\x14a2\xBDW\x80c\\\x97Z\xBB\x14a2\x99W\x80cc\xA5\x99\xA4\x14a2\x08W\x80cqP\x18\xA6\x14a1\x8CW\x80c\x82\xD3*\xD8\x14a\x1DgW\x80c\x8D\xA5\xCB[\x14a\x1D5W\x80c\x9A\xD9\x1DL\x14a\x1C\xB8W\x80c\xA0`V\xF7\x14a\x1C\x98W\x80c\xBD\xEBD-\x14a\x1CAW\x80c\xC1\xB0\xBE\xD7\x14a\x1C\x15W\x80c\xC4IV\xD1\x14a\x1B\xF8W\x80c\xC8y\xDB\xE4\x14a\x1B\xCCW\x80c\xE38E\xCF\x14a\x1BpW\x80c\xED<\xF9\x1F\x14a\x03\xD5W\x80c\xF2\xFD\xE3\x8B\x14a\x03\x04W\x80c\xFD\xDDH7\x14a\x01*Wc\xFE\x18\xAB\x91\x14a\x01\x03W_\x80\xFD[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\x01`\xFF`\x02T\x16\x1B`@Q\x90\x81R\xF3[_\x80\xFD[4a\x01&W_`\x03\x196\x01\x12a\x01&W`@Q\x7F<\xAD\xF4I\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`\x04\x82\x01R` \x81`$\x81s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16Z\xFA\x90\x81\x15a\x02\xA9W_\x91a\x02\xB4W[P` s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x91`\x04`@Q\x80\x94\x81\x93\x7F\\\x97Z\xBB\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83R\x16Z\xFA\x90\x81\x15a\x02\xA9W_\x91a\x02nW[P\x80\x15a\x02`W[` \x90`@Q\x90\x15\x15\x81R\xF3[P_T`\xA0\x1C`\xFF\x16a\x02SV[\x90P` \x81=` \x11a\x02\xA1W[\x81a\x02\x89` \x93\x83a4HV[\x81\x01\x03\x12a\x01&WQ\x80\x15\x15\x81\x03a\x01&W\x81a\x02KV[=\x91Pa\x02|V[`@Q=_\x82>=\x90\xFD[\x90P` \x81=` \x11a\x02\xFCW[\x81a\x02\xCF` \x93\x83a4HV[\x81\x01\x03\x12a\x01&WQs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x81\x03a\x01&W` a\x01\xF5V[=\x91Pa\x02\xC2V[4a\x01&W` `\x03\x196\x01\x12a\x01&W`\x045s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x80\x91\x03a\x01&Wa\x03>a4kV[\x80\x15a\x03\xA9Ws\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF_T\x82\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82\x16\x17_U\x16\x7F\x8B\xE0\x07\x9CS\x16Y\x14\x13D\xCD\x1F\xD0\xA4\xF2\x84\x19I\x7F\x97\"\xA3\xDA\xAF\xE3\xB4\x18okdW\xE0_\x80\xA3\0[\x7F\x1EO\xBD\xF7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R_`\x04R`$_\xFD[4a\x01&W` `\x03\x196\x01\x12a\x01&Wg\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF`\x045\x11a\x01&W```\x03\x19`\x0456\x03\x01\x12a\x01&W\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0\\a\x1BHW`\x01\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0]a\x04Ya4\xB7V[a\x04aa6\x8AV[P_a\x04q`\x04\x805\x01\x80a4\xEDV[_\x91P[\x80\x82\x10a\x1A\xB9W\x82a\x04\x91`D`\x045\x01`\x045`\x04\x01a5\xC1V[\x90P\x15\x15a\x04\x9E\x82a6\xF9V[\x91a\x04\xA8\x81a6\xF9V[\x91a\x04\xB1a6rV[P`@Qa\x04\xBE\x81a3\xAAV[_\x80\x82R` \x82\x01R\x81\x15a\x1A\xB2W\x82`\x01\x1C\x92[`\x1F\x19a\x04\xF8a\x04\xE2\x86a6\xE1V[\x95a\x04\xF0`@Q\x97\x88a4HV[\x80\x87Ra6\xE1V[\x01_[\x81\x81\x10a\x1AWWPP\x82\x15a\x1AOW\x93[`\x1F\x19a\x051a\x05\x1B\x87a6\xE1V[\x96a\x05)`@Q\x98\x89a4HV[\x80\x88Ra6\xE1V[\x01_[\x81\x81\x10a\x1A8WPP`@Q\x95a\x05J\x87a4+V[\x86R` \x86\x01R_`@\x86\x01R``\x85\x01R_`\x80\x85\x01R_`\xA0\x85\x01R`\xC0\x84\x01R`\xE0\x83\x01Ra\x01\0\x82\x01Ra\x05\x8C`\x045`\x04\x01`\x045`\x04\x01a4\xEDV[\x90P_[\x81\x81\x10a\x0C\x1AW\x82`\x80\x81\x01Qa\x06\x1BW[a\x05\xE5\x81a\x05\xF3` \x7F\x10\xDDR\x8D\xB2\xC4\x9A\xDDeEg\x9B\x97m\xF9\r$\xC05\xD6\xA7[\x17\xF4\x1Bp\x0E\x8C\x18\xCASd\x94Q\x92\x01Q`@Q\x93\x84\x93`@\x85R`@\x85\x01\x90a6\x12V[\x90\x83\x82\x03` \x85\x01Ra6\x12V[\x03\x90\xA1_\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0]\0[a\x06qa\x06za\x065`$`\x045\x01`\x045`\x04\x01a5\xC1V[\x91\x90a\x06K`D`\x045\x01`\x045`\x04\x01a5\xC1V[\x94\x90\x93a\x06k``\x88\x01Q\x93\x88Q` \x81Q`\x05\x1B\x91\x01 \x926\x91a9PV[\x90aM\x19V[\x90\x93\x91\x93aMSV[` \x81Q\x91\x01Q\x90_R` Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x80`@_ \x16\x91\x16\x90\x80\x82\x03a\x0B\xECWPP`\xC0\x83\x01Qa\x07RW[PP`@\x81\x01Q\x90a\x06\xC9\x82aL\xA2V[\x15a\x07&Wa\x05\xE5\x90\x7F\n-\xC5H\xED\x95\n\xCC\xB4\r]xT\x1F9T\xC5\xE1\x82\xA8\xEC\xF1\x9EX\x1AO\"c\xF6\x1FY\xD2` \x7F\x10\xDDR\x8D\xB2\xC4\x9A\xDDeEg\x9B\x97m\xF9\r$\xC05\xD6\xA7[\x17\xF4\x1Bp\x0E\x8C\x18\xCASd\x94`@Q\x90\x81R\xA1\x91PPa\x05\xA2V[P\x7F\xDBx\x8C+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[\x81`\x04\x11a\x01&Wa\x07\x86\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x825\x16aA\xF8V[` \x83\x01Q`\xE0\x84\x01Qa\x01\0\x85\x01Q\x90`@Q\x92a\x07\xA4\x84a4\x0FV[\x83R` \x83\x01\x90\x80\x82R`@\x84\x01\x92\x83RQ\x92` \x93`@Qa\x07\xC7\x86\x82a4HV[_\x81R\x92`@Qa\x07\xD8\x87\x82a4HV[_\x81R\x94_\x91[\x87\x84\x84\x10a\n\\WPPPPa\x08\x1Dc\xFF\xFF\xFF\xFF\x82\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x93\x81`\x01\x1B\x91\x80\x83\x04`\x02\x14\x90\x15\x17\x15a\n/W`$\x86a\x08hc\xFF\xFF\xFF\xFF`(\x95\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x94Q\x94\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82`@Q\x98\x82\x82\x8B\x01\x9B`\xE0\x1B\x16\x8BR\x80Q\x91\x82\x91\x01\x86\x8B\x01^\x88\x01\x91\x7F\x91\x9E\x13\0\x1C\xD31\x9B\xE5\xA5\xA7\xCB\x18\x92\x03\xBE\x086t\xAC\xB3\xFF\xF2=\x05\xAA\xE9\xC3\xED\x861M\x85\x84\x01R`\xE0\x1B\x16\x93\x84`D\x83\x01R\x80Q\x92\x83\x91\x01`H\x83\x01^\x01\x01\x90`$\x82\x01R\x01\x84\x82Q\x91\x92\x01\x90_[\x86\x82\x82\x10a\n\x1BWPPPP\x90a\t\x18\x81_\x94\x93\x03`\x1F\x19\x81\x01\x83R\x82a4HV[`@Q\x91\x82\x91Q\x80\x91\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xA9W_Q\x91`\xA0\x84\x01Q\x15a\tGW[Pa\x06\xB8V[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x80;\x15a\x01&W_\x92a\t\xC9\x92`@Q\x95\x86\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R```\x04\x86\x01R`d\x85\x01\x91a8DV[\x90\x7F!;?@\xD7\xC1\x13\xC1\xA0\x12\x07/\xCDy\x1F\xA4K\xF5\x16j#\0\x12\x160\xBD2(\xE2\xB0\x08'`$\x84\x01R`D\x83\x01R\x03\x91Z\xFA\x80\x15a\x02\xA9Wa\n\x0BW[\x80\x80a\tAV[_a\n\x15\x91a4HV[\x81a\n\x04V[\x83Q\x85R\x93\x84\x01\x93\x90\x92\x01\x91`\x01\x01a\x08\xF6V[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x11`\x04R`$_\xFD[\x90\x91\x92\x96\x95a\n\xAF\x90\x82\x80a\n{a\nu\x8C\x88Qa7{V[QaBxV[`@Q\x95\x84\x87\x95Q\x91\x82\x91\x01\x84\x87\x01^\x84\x01\x90\x82\x82\x01_\x81R\x81Q\x93\x84\x92\x01\x90^\x01\x01_\x81R\x03`\x1F\x19\x81\x01\x83R\x82a4HV[\x94\x82Q\x87`\x01\x1B\x90\x88\x82\x04`\x02\x14\x89\x15\x17\x15a\n/Wa\n\xD2\x82a\n\xD8\x92a7{V[QaB\xD6V[\x84Q\x90`\x01\x83\x01\x80\x93\x11a\n/W`\x01\x93`\x04\x8C\x81\x93a\n\xFFa\n\xD2\x83\x98a\x0B\xE3\x98a7{V[\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83\x80a\x0BXc\xFF\xFF\xFF\xFF\x86Q`\x02\x1C\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[a\x0B\x8Ec\xFF\xFF\xFF\xFF\x86Q`\x02\x1C\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x95\x84`@Q\x9D\x8B\x8F\x82\x81\x9EQ\x93\x84\x93\x01\x91\x01^\x8B\x01\x92`\xE0\x1B\x16\x83\x83\x01R\x80Q\x92\x83\x91\x01`$\x83\x01^\x01\x01\x92`\xE0\x1B\x16\x84\x83\x01R\x80Q\x92\x83\x91\x01`\x08\x83\x01^\x01\x01_\x83\x82\x01R\x03\x01`\x1F\x19\x81\x01\x83R\x82a4HV[\x96\x01\x91\x90a\x07\xDFV[\x7F\xE6\xD4KL\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$R`D_\xFD[a\x0C2\x81a\x0C,`\x04\x805\x01\x80a4\xEDV[\x90a5AV[a\x0C?` \x82\x01\x82a4\xEDV[\x80\x91P`\x01\x1B\x81\x81\x04`\x02\x14\x82\x15\x17\x15a\n/Wa\x0C\\\x90a6\xF9V[\x90_[\x81\x81\x10a\x19\xE1WPP`\x01`\xFF\x82Qo\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11`\x07\x1Bg\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x82\x1C\x11`\x06\x1B\x17c\xFF\xFF\xFF\xFF\x82\x82\x1C\x11`\x05\x1B\x17a\xFF\xFF\x82\x82\x1C\x11`\x04\x1B\x17\x82\x82\x82\x1C\x11`\x03\x1B\x17`\x0F\x82\x82\x1C\x11`\x02\x1B\x17}\x01\x01\x02\x02\x02\x02\x03\x03\x03\x03\x03\x03\x03\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82\x82\x1C\x1A\x17\x90\x83\x82\x1B\x10\x01\x16\x1Ba\x0C\xF5\x81a6\xF9V[\x91_[\x82\x81\x10a\x19\x86WPP[`\x01\x81\x11a\x19\x07WPa\r\x14\x90a7nV[Q\x90a\r#` \x82\x01\x82a4\xEDV[\x90P_[\x81\x81\x10a\rsWPP`@`\x01\x93\x92a\ra\x83\x7F\x1C\xC9\xA0u]\xD74\xC1\xEB\xFE\x98\xB6\x8E\xCE \x007\xE3c\xEB6m\r\xEE\x04\xE4 \xE2\xF2<\xC0\x10\x94a4\xEDV[\x83Q\x92\x83R` \x83\x01RP\xA1\x01a\x05\x90V[a\r\x8A\x81a\r\x84` \x86\x01\x86a4\xEDV[\x90a5\x81V[\x96a\r\x93a6\x8AV[P` \x88\x01\x90``\x89\x015\x80_R`\x05` R`@_ T\x15a\x18\xDCWP`\xC0\x81\x01Q\x86\x90\x15a\x17dWa\x0E\x04a\x0E\x0F\x93a\r\xEF`\xE0\x85\x01Q`\x80\x86\x01Q`\x01\x1C\x90a\r\xDF6\x85a7\x9CV[a\r\xE9\x83\x83a7{V[Ra7{V[P[a\r\xFB\x88\x80a4\xEDV[\x90\x915\x91a8\xD5V[`@\x8B\x015\x90a:\x95V[\x96a\x0E(a\x0E\x1D\x85\x80a4\xEDV[`\x80\x84\x015\x91a8\xD5V[`\xA0\x82\x015a\x0E5a6\x8AV[P\x80` \x83\x015\x03a\x170WP`\x80\x816\x03\x12a\x01&W`@Qa\x0EX\x81a3\xF3V[\x815\x81R` \x82\x015` \x82\x01R`@\x82\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x82\x01\x90`\x80\x826\x03\x12a\x01&W`@Q\x91a\x0E\x94\x83a3\xF3V[\x805g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa\x0E\xB2\x906\x90\x83\x01a9\xA1V[\x83R` \x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa\x0E\xD5\x906\x90\x83\x01a9\xA1V[` \x84\x01R`@\x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa\x0E\xFB\x906\x90\x83\x01a9\xA1V[`@\x84\x01R``\x81\x015\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&Wa\x0F!\x916\x91\x01a9\xA1V[``\x83\x01R`@\x81\x01\x91\x82R``\x83\x01\x90\x815g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa\x0FP\x906\x90\x86\x01a9\x86V[``\x82\x01Ra\x0F]a7*V[PQ\x91Q`@Q\x92a\x0Fn\x84a3\xF3V[\x83R_` \x84\x01R`@\x83\x01\x89\x90R``\x83\x01R`\xC0\x8B\x01Q\x15a\x16\x01WPa\x0F\xA7\x90a\x01\0\x8B\x01Q`\x80\x8C\x01Q\x91a\r\xE9\x83\x83a7{V[P[a\x0F\xC3a\x0F\xB9`@\x83\x01\x83a8\x88V[`@\x81\x01\x90a4\xEDV[\x90P_[\x81\x81\x10a\x14\x16WPP\x88Q`\x80\x8A\x01\x90a\x0F\xE5\x835\x91\x83Q\x90a7{V[Ra\x10\x08` \x8B\x01Q\x91\x80Q\x90a\x0F\xFB\x82a:hV[\x90R` \x84\x015\x92a7{V[R`\xFF`\x02T\x16`\x01Ta\x10\x1B\x81a:hV[`\x01U\x90\x825\x91_[\x82\x81\x10a\x13pWPP`\x01T`\x01`\xFF`\x02T\x16\x1B\x14a\x13/W[P`@\x8A\x01Ra\x10[a\x10U`@\x83\x01\x83a8\x88V[\x80a4\xEDV[_[\x81\x81\x10a\x12\xCFWPPPa\x10\x81a\x10w`@\x83\x01\x83a8\x88V[` \x81\x01\x90a4\xEDV[_[\x81\x81\x10a\x12oWPPPa\x10\x9Da\x0F\xB9`@\x83\x01\x83a8\x88V[_[\x81\x81\x10a\x11\xFDWPPPa\x10\xC3a\x10\xB9`@\x83\x01\x83a8\x88V[``\x81\x01\x90a4\xEDV[\x90\x91_[\x82\x81\x10a\x11\x81WPPPP``\x88\x01\x80Q`@Q\x92a\x10\xE5\x84a3\xAAV[`\xC0\x81\x015\x84R`\xE0` \x85\x01\x91\x015\x81R`@Q\x93a\x11\x04\x85a3\xAAV[_\x85R_` \x86\x01Ra\x11\x1A\x81Q\x83Q\x90aEcV[\x15a\x11IW\x91a\x11;\x91`\x01\x96\x95\x94\x93` \x83Q\x93\x01Q\x90Q\x91Q\x92aE\xC5V[` \x84\x01R\x82RR\x01a\r'V[`D\x91`@Q\x91\x7F\xB8\xA0\xE8\xA1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83RQ`\x04\x83\x01RQ`$\x82\x01R\xFD[a\x11\x8C\x81\x84\x86a5AV[5\x90`\x02\x82\x10\x15a\x01&W`\x01\x80\x92\x14a\x11\xA7W[\x01a\x10\xC7V[a\x11\xF5\x7F\xA4\x94\xDA\xC4\xB7\x18HCX?\x97.\x06x>,;\xB4\x7FO\x017\xB8\xDFR\xA8`\xDF\x07!\x9F\x8Ca\x11\xE3a\x11\xD9\x84\x88\x8Aa5AV[` \x81\x01\x90a5\xC1V[`@Q\x875\x94\x90\x92\x83\x92\x90\x87\x84aELV[\x03\x90\xA2a\x11\xA1V[a\x12\x08\x81\x83\x85a5AV[5\x90`\x02\x82\x10\x15a\x01&W`\x01\x80\x92\x14a\x12#W[\x01a\x10\x9FV[a\x12g\x7F\x9Ca\xB2\x90\xF61\t\x7FV'<\xF4\xDA\xF4\r\xF1\xFF\x9C\xCC3\xF1\x01\xD4d\x83}\xA1\xF5\xAE\x18\xBDYa\x12Ua\x11\xD9\x84\x87\x89a5AV[`@Q\x895\x94\x90\x92\x83\x92\x90\x87\x84aELV[\x03\x90\xA2a\x12\x1DV[a\x12z\x81\x83\x85a5AV[5\x90`\x02\x82\x10\x15a\x01&W`\x01\x80\x92\x14a\x12\x95W[\x01a\x10\x83V[a\x12\xC7\x7FH$8s\xB4u-\xDC\xB4^\r{\x11\xC4\xC2fX>^\t\x9A\x0By\x8F\xDD\x9C\x1A\xF7\xD4\x93$\xF3a\x12Ua\x11\xD9\x84\x87\x89a5AV[\x03\x90\xA2a\x12\x8FV[a\x12\xDA\x81\x83\x85a5AV[5\x90`\x02\x82\x10\x15a\x01&W`\x01\x80\x92\x14a\x12\xF5W[\x01a\x10]V[a\x13'\x7F:\x13M\x01\xC0x\x03\0<c0\x17\x17\xDD\xC4a.lG\xAE@\x8E\xEE\xA3\",\xDE\xD52\xD0*\xE6a\x12Ua\x11\xD9\x84\x87\x89a5AV[\x03\x90\xA2a\x12\xEFV[\x90a\x13j\x91a\x13=\x82aJ*V[`\x03_R\x7F\xC2WZ\x0E\x9EY<\0\xF9Y\xF8\xC9/\x12\xDB(i\xC39Z;\x05\x02\xD0^%\x16Doq\xF8[\x01T\x90aH)V[\x8Aa\x10?V[\x90\x92`\x01\x90\x81\x85\x16a\x13\xDEW\x7F@W\x87\xFA\x12\xA8#\xE0\xF2\xB7c\x1C\xC4\x1B;\xA8\x82\x8B3!\xCA\x81\x11\x11\xFAu\xCD:\xA3\xBBZ\xCE\x83\x01\x81\x90U`\x03_R\x7F\xC2WZ\x0E\x9EY<\0\xF9Y\xF8\xC9/\x12\xDB(i\xC39Z;\x05\x02\xD0^%\x16Doq\xF8[\x83\x01Ta\x13\xD3\x91aH)V[\x93[\x81\x1C\x91\x01a\x10$V[`\x02_R\x7F@W\x87\xFA\x12\xA8#\xE0\xF2\xB7c\x1C\xC4\x1B;\xA8\x82\x8B3!\xCA\x81\x11\x11\xFAu\xCD:\xA3\xBBZ\xCE\x83\x01Ta\x14\x10\x91\x90aH)V[\x93a\x13\xD5V[a\x14-a\x11\xD9\x82a\x0C,a\x0F\xB9`@\x88\x01\x88a8\x88V[\x81\x01``\x82\x82\x03\x12a\x01&W\x815\x91s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x80\x93\x03a\x01&W` \x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x82a\x14z\x91\x83\x01a9\x86V[\x91`@\x82\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa\x14\x99\x92\x01a9\x86V[\x90`@Q\x91\x7F3\xA8\x92\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83R` \x87\x015`\x04\x84\x01R`@`$\x84\x01R_\x83\x80a\x14\xE2`D\x82\x01\x86aI\xE0V[\x03\x81\x83\x88Z\xF1\x92\x83\x15a\x02\xA9W_\x93a\x15\x85W[P\x82Q` \x84\x01 \x81Q` \x83\x01 \x03a\x15JWP`\x01\x93\x92\x91\x7F\xCD\xDB2z\xDB1\xFET7\xDF*\x8Ch0\x1B\xB1:k\xAA\xE42\xA8\x04\x83\x8C\xAA\xF6\x82Pj\xAD\xF1\x91a\x15A`@Q\x92\x83\x92\x83aJ\x05V[\x03\x90\xA2\x01a\x0F\xC7V[\x90Pa\x15\x81`@Q\x92\x83\x92\x7F\xC5\x04\xFA\xDA\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x84R`\x04\x84\x01aJ\x05V[\x03\x90\xFD[\x90\x92P=\x80_\x83>a\x15\x97\x81\x83a4HV[\x81\x01\x90` \x81\x83\x03\x12a\x01&W\x80Q\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&W\x01\x81`\x1F\x82\x01\x12\x15a\x01&W\x80Q\x90a\x15\xCE\x82a94V[\x92a\x15\xDC`@Q\x94\x85a4HV[\x82\x84R` \x83\x83\x01\x01\x11a\x01&W\x81_\x92` \x80\x93\x01\x83\x86\x01^\x83\x01\x01R\x91\x8Fa\x14\xF6V[a\x16\x0B\x81\x84a5\xC1V[`\x04\x11a\x01&W\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0a\x16>\x915\x16aA\xF8V[`\xA0\x8B\x01Q\x15a\x16PW[PPa\x0F\xA9V[a\x16\xA1\x90` _\x81a\x16\x99s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x94\x88a5\xC1V[\x95\x90\x96aB\xD6V[`@Q\x91\x81\x83\x92Q\x91\x82\x91\x01\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xA9W_Q\x90\x80;\x15a\x01&Wa\x17\x0B\x93_\x93`@Q\x95\x86\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R` \x8B\x015\x91`\x04\x86\x01a8dV[\x03\x91Z\xFA\x80\x15a\x02\xA9Wa\x17 W[\x80a\x16IV[_a\x17*\x91a4HV[\x89a\x17\x1AV[` \x92P\x7F\x18\xF69\xD8\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R\x015`$R`D_\xFD[Pa\x17o\x89\x80a5\xC1V[`\x04\x11a\x01&W\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0a\x17\xA2\x915\x16aA\xF8V[\x85`\xA0\x82\x01Q\x15a\x17\xBAW[a\x0E\x04a\x0E\x0F\x93a\r\xF1V[Ps\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16a\x17\xFC\x8A\x80a5\xC1V[` _\x81a\x18\x12a\x18\r6\x8Aa7\x9CV[aBxV[`@Q\x91\x81\x83\x92Q\x91\x82\x91\x01\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xA9W_Q\x92\x80;\x15a\x01&W_\x92a\x18~\x92`@Q\x95\x86\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R```\x04\x86\x01R`d\x85\x01\x91a8DV[\x90\x7F\x91\x9E\x13\0\x1C\xD31\x9B\xE5\xA5\xA7\xCB\x18\x92\x03\xBE\x086t\xAC\xB3\xFF\xF2=\x05\xAA\xE9\xC3\xED\x861M`$\x84\x01R`D\x83\x01R\x03\x91Z\xFA\x80\x15a\x02\xA9Wa\x0E\x0F\x93\x88\x92a\x0E\x04\x92a\x18\xCCW[P\x93PPa\x17\xAEV[_a\x18\xD6\x91a4HV[\x8Ca\x18\xC3V[\x7F\xF9\x84\x9E\xA3\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[`\x01\x1C_[\x81\x81\x10a\x19\x19WPa\r\x02V[\x80`\x01\x1B\x90\x7F\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x81\x03a\n/Wa\x19Q\x82\x85a7{V[Q\x91`\x01\x81\x01\x80\x91\x11a\n/W`\x01\x92a\x19na\x19u\x92\x87a7{V[Q\x90aH)V[a\x19\x7F\x82\x86a7{V[R\x01a\x19\x0CV[`\x01\x90\x82Q\x81\x10_\x14a\x19\xB0Wa\x19\x9D\x81\x84a7{V[Qa\x19\xA8\x82\x87a7{V[R[\x01a\x0C\xF8V[\x7F\xCC\x1D/\x83\x84E\xDBz\xECC\x1D\xF9\xEE\x8A\x87\x1F@\xE7\xAA^\x06O\xC0Vc>\xF8\xC6\x0F\xAB{\x06a\x19\xDB\x82\x87a7{V[Ra\x19\xAAV[a\x19\xF2\x81a\r\x84` \x87\x01\x87a4\xEDV[\x90\x80`\x01\x1B\x81\x81\x04`\x02\x14\x82\x15\x17\x15a\n/W` \x83\x015a\x1A\x14\x82\x87a7{V[R`\x01\x81\x01\x80\x91\x11a\n/Wa\x1A1`\x80`\x01\x94\x015\x91\x86a7{V[R\x01a\x0C_V[` \x90a\x1ACa7*V[\x82\x82\x8A\x01\x01R\x01a\x054V[P_\x93a\x05\x0CV[` \x90`@Qa\x1Af\x81a3\xF3V[`@Qa\x1Ar\x81a4\x0FV[_\x81R_\x84\x82\x01R_`@\x82\x01R\x81R`@Qa\x1A\x8E\x81a3\xAAV[_\x81R_\x84\x82\x01R\x83\x82\x01R_`@\x82\x01R_``\x82\x01R\x82\x82\x89\x01\x01R\x01a\x04\xFBV[_\x92a\x04\xD3V[\x90\x91a\x1A\xCD\x83a\x0C,`\x04\x805\x01\x80a4\xEDV[\x90a\x1A\xE7a\x1A\xDE` \x84\x01\x84a4\xEDV[\x93\x80\x91Pa4\xEDV[\x92\x80\x91P`\x01\x1B\x90\x80\x82\x04`\x02\x14\x90\x15\x17\x15a\n/W\x80\x83\x03a\x1B\x19WP`\x01\x91a\x1B\x11\x91a7\x8FV[\x92\x01\x90a\x04uV[\x82\x7F\xD3\xBE\xE7\x8D\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$R`D_\xFD[\x7F>\xE5\xAE\xB5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04_\xFD[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `@Q\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x81R\xF3[4a\x01&W` `\x03\x196\x01\x12a\x01&W`\x045_R`\x05` R` `@_ T\x15\x15`@Q\x90\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\x01T`@Q\x90\x81R\xF3[4a\x01&W` `\x03\x196\x01\x12a\x01&W`\x045_R`\x07` R` `@_ T\x15\x15`@Q\x90\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W`\x04T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x01\x90\x81\x11a\n/Wa\x1C\x89` \x91a6EV[\x90T\x90`\x03\x1B\x1C`@Q\x90\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\xFF`\x02T\x16`@Q\x90\x81R\xF3[4a\x01&W` `\x03\x196\x01\x12a\x01&W`\x045`\x06T\x81\x10\x15a\x1D\x08W`\x06_R\x7F\xF6R\"#\x13\xE2\x84YR\x8D\x92\x0Be\x11\\\x16\xC0O>\xFC\x82\xAA\xED\xC9{\xE5\x9F?7|\r?\x01T`@Q\x90\x81R` \x90\xF3[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`2`\x04R`$_\xFD[4a\x01&W_`\x03\x196\x01\x12a\x01&W` s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF_T\x16`@Q\x90\x81R\xF3[4a\x01&W`@`\x03\x196\x01\x12a\x01&Wg\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF`\x045\x11a\x01&W```\x03\x19`\x0456\x03\x01\x12a\x01&W`$5\x80\x15\x15\x80\x91\x03a\x01&WZ\x90\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0\\a\x1BHW`\x01\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0]a\x1D\xFAa4\xB7V[a\x1E\x02a6\x8AV[P_\x90a\x1E\x13`\x04\x805\x01\x80a4\xEDV[_\x91P[\x80\x82\x10a15WPPa\x1E4`D`\x045\x01`\x045`\x04\x01a5\xC1V[\x90P\x15\x15\x91a\x1EB\x81a6\xF9V[\x92a\x1EL\x82a6\xF9V[\x92a\x1EUa6rV[P`@Qa\x1Eb\x81a3\xAAV[_\x80\x82R` \x82\x01R\x82\x15a1.W\x83`\x01\x1C\x93[`\x1F\x19a\x1E\x86a\x05\x1B\x87a6\xE1V[\x01_[\x81\x81\x10a0\xD3WPP\x83\x15a0\xCBW\x94[`\x1F\x19a\x1E\xBFa\x1E\xA9\x88a6\xE1V[\x97a\x1E\xB7`@Q\x99\x8Aa4HV[\x80\x89Ra6\xE1V[\x01_[\x81\x81\x10a0\xB4WPP`@Q\x96a\x1E\xD8\x88a4+V[\x87R` \x87\x01R_`@\x87\x01R``\x86\x01R_`\x80\x86\x01R`\xA0\x85\x01R`\xC0\x84\x01R`\xE0\x83\x01Ra\x01\0\x82\x01R\x90a\x1F\x1A`\x045`\x04\x01`\x045`\x04\x01a4\xEDV[\x90P_[\x81\x81\x10a$DWPP`\x80\x82\x01Qa\x1F\xCFW[\x7F\x10\xDDR\x8D\xB2\xC4\x9A\xDDeEg\x9B\x97m\xF9\r$\xC05\xD6\xA7[\x17\xF4\x1Bp\x0E\x8C\x18\xCASda\x05\xE5\x83a\x1Fw` a\x1F\xA4\x96Q\x92\x01Q`@Q\x93\x84\x93`@\x85R`@\x85\x01\x90a6\x12V[\x03\x90\xA1_\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0]Z\x90a3\x9DV[\x7Fo\x14\x981\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[a\x06qa \x1Fa\x1F\xE9`$`\x045\x01`\x045`\x04\x01a5\xC1V[\x91\x90a\x1F\xFF`D`\x045\x01`\x045`\x04\x01a5\xC1V[\x94\x90\x93a\x06k``\x89\x01Q\x93\x89Q` \x81Q`\x05\x1B\x91\x01 \x926\x91a9PV[` \x81Q\x91\x01Q\x90_R` Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x80`@_ \x16\x91\x16\x90\x80\x82\x03a\x0B\xECWPP`\xC0\x84\x01Qa \xFBW[PP`@\x82\x01Q\x91a n\x83aL\xA2V[\x15a \xCFWa\x05\xE5\x7F\x10\xDDR\x8D\xB2\xC4\x9A\xDDeEg\x9B\x97m\xF9\r$\xC05\xD6\xA7[\x17\xF4\x1Bp\x0E\x8C\x18\xCASd\x91\x7F\n-\xC5H\xED\x95\n\xCC\xB4\r]xT\x1F9T\xC5\xE1\x82\xA8\xEC\xF1\x9EX\x1AO\"c\xF6\x1FY\xD2` a\x1F\xA4\x96`@Q\x90\x81R\xA1\x93PPPa\x1F1V[\x82\x7F\xDBx\x8C+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[\x81`\x04\x11a\x01&Wa!/\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x825\x16aA\xF8V[` \x84\x01Q`\xE0\x85\x01Qa\x01\0\x86\x01Q\x90`@Q\x92a!M\x84a4\x0FV[\x83R` \x83\x01\x90\x80\x82R`@\x84\x01\x92\x83RQ\x92` \x93`@Qa!p\x86\x82a4HV[_\x81R\x92`@Qa!\x81\x87\x82a4HV[_\x81R\x94_\x91[\x87\x84\x84\x10a#\xD8WPPPPa!\xC6c\xFF\xFF\xFF\xFF\x82\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x93\x81`\x01\x1B\x91\x80\x83\x04`\x02\x14\x90\x15\x17\x15a\n/W`$\x86a\"\x11c\xFF\xFF\xFF\xFF`(\x95\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x94Q\x94\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82`@Q\x98\x82\x82\x8B\x01\x9B`\xE0\x1B\x16\x8BR\x80Q\x91\x82\x91\x01\x86\x8B\x01^\x88\x01\x91\x7F\x91\x9E\x13\0\x1C\xD31\x9B\xE5\xA5\xA7\xCB\x18\x92\x03\xBE\x086t\xAC\xB3\xFF\xF2=\x05\xAA\xE9\xC3\xED\x861M\x85\x84\x01R`\xE0\x1B\x16\x93\x84`D\x83\x01R\x80Q\x92\x83\x91\x01`H\x83\x01^\x01\x01\x90`$\x82\x01R\x01\x84\x82Q\x91\x92\x01\x90_[\x86\x82\x82\x10a#\xC4WPPPP\x90a\"\xC1\x81_\x94\x93\x03`\x1F\x19\x81\x01\x83R\x82a4HV[`@Q\x91\x82\x91Q\x80\x91\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xA9W_Q\x91`\xA0\x85\x01Q\x15a\"\xF0W[Pa ]V[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x80;\x15a\x01&W_\x92a#r\x92`@Q\x95\x86\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R```\x04\x86\x01R`d\x85\x01\x91a8DV[\x90\x7F!;?@\xD7\xC1\x13\xC1\xA0\x12\x07/\xCDy\x1F\xA4K\xF5\x16j#\0\x12\x160\xBD2(\xE2\xB0\x08'`$\x84\x01R`D\x83\x01R\x03\x91Z\xFA\x80\x15a\x02\xA9Wa#\xB4W[\x80\x80a\"\xEAV[_a#\xBE\x91a4HV[\x82a#\xADV[\x83Q\x85R\x93\x84\x01\x93\x90\x92\x01\x91`\x01\x01a\"\x9FV[\x90\x91\x92\x96\x95a#\xF1\x90\x82\x80a\n{a\nu\x8C\x88Qa7{V[\x94\x82Q\x87`\x01\x1B\x90\x88\x82\x04`\x02\x14\x89\x15\x17\x15a\n/Wa\n\xD2\x82a$\x14\x92a7{V[\x84Q\x90`\x01\x83\x01\x80\x93\x11a\n/W`\x01\x93`\x04\x8C\x81\x93a\n\xFFa\n\xD2\x83\x98a$;\x98a7{V[\x96\x01\x91\x90a!\x88V[a$V\x81a\x0C,`\x04\x805\x01\x80a4\xEDV[a$c` \x82\x01\x82a4\xEDV[\x80\x91P`\x01\x1B\x81\x81\x04`\x02\x14\x82\x15\x17\x15a\n/Wa$\x80\x90a6\xF9V[\x90_[\x81\x81\x10a0]WPP`\x01`\xFF\x82Qo\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11`\x07\x1Bg\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x82\x1C\x11`\x06\x1B\x17c\xFF\xFF\xFF\xFF\x82\x82\x1C\x11`\x05\x1B\x17a\xFF\xFF\x82\x82\x1C\x11`\x04\x1B\x17\x82\x82\x82\x1C\x11`\x03\x1B\x17`\x0F\x82\x82\x1C\x11`\x02\x1B\x17}\x01\x01\x02\x02\x02\x02\x03\x03\x03\x03\x03\x03\x03\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82\x82\x1C\x1A\x17\x90\x83\x82\x1B\x10\x01\x16\x1Ba%\x19\x81a6\xF9V[\x91_[\x82\x81\x10a0\x02WPP[`\x01\x81\x11a/\x8AWPa%8\x90a7nV[Q\x90a%G` \x82\x01\x82a4\xEDV[\x90P_[\x81\x81\x10a%\x97WPP`@`\x01\x93\x92a%\x85\x83\x7F\x1C\xC9\xA0u]\xD74\xC1\xEB\xFE\x98\xB6\x8E\xCE \x007\xE3c\xEB6m\r\xEE\x04\xE4 \xE2\xF2<\xC0\x10\x94a4\xEDV[\x83Q\x92\x83R` \x83\x01RP\xA1\x01a\x1F\x1EV[a%\xA8\x81a\r\x84` \x86\x01\x86a4\xEDV[\x97a%\xB1a6\x8AV[P` \x89\x01\x90``\x8A\x015\x80_R`\x05` R`@_ T\x15a\x18\xDCWP`\xC0\x81\x01Q\x86\x90\x15a.\x17Wa%\xFDa&\x08\x93a\r\xEF`\xE0\x85\x01Q`\x80\x86\x01Q`\x01\x1C\x90a\r\xDF6\x85a7\x9CV[`@\x8C\x015\x90a:\x95V[\x97a&\x16a\x0E\x1D\x85\x80a4\xEDV[`\xA0\x82\x015a&#a6\x8AV[P\x80` \x83\x015\x03a\x170WP`\x80\x816\x03\x12a\x01&W`@Qa&F\x81a3\xF3V[\x815\x81R` \x82\x015` \x82\x01R`@\x82\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x82\x01\x90`\x80\x826\x03\x12a\x01&W`@Q\x91a&\x82\x83a3\xF3V[\x805g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa&\xA0\x906\x90\x83\x01a9\xA1V[\x83R` \x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa&\xC3\x906\x90\x83\x01a9\xA1V[` \x84\x01R`@\x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa&\xE9\x906\x90\x83\x01a9\xA1V[`@\x84\x01R``\x81\x015\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&Wa'\x0F\x916\x91\x01a9\xA1V[``\x83\x01R`@\x81\x01\x91\x82R``\x83\x01\x90\x815g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa'>\x906\x90\x86\x01a9\x86V[``\x82\x01Ra'Ka7*V[PQ\x91Q`@Q\x92a'\\\x84a3\xF3V[\x83R_` \x84\x01R`@\x83\x01\x89\x90R``\x83\x01R`\xC0\x8C\x01Q\x15a,\xF0WPa'\x95\x90a\x01\0\x8C\x01Q`\x80\x8D\x01Q\x91a\r\xE9\x83\x83a7{V[P[a'\xA7a\x0F\xB9`@\x83\x01\x83a8\x88V[\x90P_[\x81\x81\x10a+@WPP\x89Q`\x80\x8B\x01\x90a'\xC9\x835\x91\x83Q\x90a7{V[Ra'\xDF` \x8C\x01Q\x91\x80Q\x90a\x0F\xFB\x82a:hV[R`\xFF`\x02T\x16`\x01Ta'\xF2\x81a:hV[`\x01U\x90\x825\x91_[\x82\x81\x10a*\x9AWPP`\x01T`\x01`\xFF`\x02T\x16\x1B\x14a*\x86W[P`@\x8B\x01Ra(,a\x10U`@\x83\x01\x83a8\x88V[_[\x81\x81\x10a*&WPPPa(Ha\x10w`@\x83\x01\x83a8\x88V[_[\x81\x81\x10a)\xC6WPPPa(da\x0F\xB9`@\x83\x01\x83a8\x88V[_[\x81\x81\x10a)fWPPPa(\x80a\x10\xB9`@\x83\x01\x83a8\x88V[\x90\x91_[\x82\x81\x10a)\x06WPPPP``\x89\x01\x80Q`@Q\x92a(\xA2\x84a3\xAAV[`\xC0\x81\x015\x84R`\xE0` \x85\x01\x91\x015\x81R`@Q\x93a(\xC1\x85a3\xAAV[_\x85R_` \x86\x01Ra(\xD7\x81Q\x83Q\x90aEcV[\x15a\x11IW\x91a(\xF8\x91`\x01\x96\x95\x94\x93` \x83Q\x93\x01Q\x90Q\x91Q\x92aE\xC5V[` \x84\x01R\x82RR\x01a%KV[a)\x11\x81\x84\x86a5AV[5\x90`\x02\x82\x10\x15a\x01&W`\x01\x80\x92\x14a),W[\x01a(\x84V[a)^\x7F\xA4\x94\xDA\xC4\xB7\x18HCX?\x97.\x06x>,;\xB4\x7FO\x017\xB8\xDFR\xA8`\xDF\x07!\x9F\x8Ca\x11\xE3a\x11\xD9\x84\x88\x8Aa5AV[\x03\x90\xA2a)&V[a)q\x81\x83\x85a5AV[5\x90`\x02\x82\x10\x15a\x01&W`\x01\x80\x92\x14a)\x8CW[\x01a(fV[a)\xBE\x7F\x9Ca\xB2\x90\xF61\t\x7FV'<\xF4\xDA\xF4\r\xF1\xFF\x9C\xCC3\xF1\x01\xD4d\x83}\xA1\xF5\xAE\x18\xBDYa\x12Ua\x11\xD9\x84\x87\x89a5AV[\x03\x90\xA2a)\x86V[a)\xD1\x81\x83\x85a5AV[5\x90`\x02\x82\x10\x15a\x01&W`\x01\x80\x92\x14a)\xECW[\x01a(JV[a*\x1E\x7FH$8s\xB4u-\xDC\xB4^\r{\x11\xC4\xC2fX>^\t\x9A\x0By\x8F\xDD\x9C\x1A\xF7\xD4\x93$\xF3a\x12Ua\x11\xD9\x84\x87\x89a5AV[\x03\x90\xA2a)\xE6V[a*1\x81\x83\x85a5AV[5\x90`\x02\x82\x10\x15a\x01&W`\x01\x80\x92\x14a*LW[\x01a(.V[a*~\x7F:\x13M\x01\xC0x\x03\0<c0\x17\x17\xDD\xC4a.lG\xAE@\x8E\xEE\xA3\",\xDE\xD52\xD0*\xE6a\x12Ua\x11\xD9\x84\x87\x89a5AV[\x03\x90\xA2a*FV[\x90a*\x94\x91a\x13=\x82aJ*V[\x8Ba(\x16V[\x90\x92`\x01\x90\x81\x85\x16a+\x08W\x7F@W\x87\xFA\x12\xA8#\xE0\xF2\xB7c\x1C\xC4\x1B;\xA8\x82\x8B3!\xCA\x81\x11\x11\xFAu\xCD:\xA3\xBBZ\xCE\x83\x01\x81\x90U`\x03_R\x7F\xC2WZ\x0E\x9EY<\0\xF9Y\xF8\xC9/\x12\xDB(i\xC39Z;\x05\x02\xD0^%\x16Doq\xF8[\x83\x01Ta*\xFD\x91aH)V[\x93[\x81\x1C\x91\x01a'\xFBV[`\x02_R\x7F@W\x87\xFA\x12\xA8#\xE0\xF2\xB7c\x1C\xC4\x1B;\xA8\x82\x8B3!\xCA\x81\x11\x11\xFAu\xCD:\xA3\xBBZ\xCE\x83\x01Ta+:\x91\x90aH)V[\x93a*\xFFV[a+Wa\x11\xD9\x82a\x0C,a\x0F\xB9`@\x88\x01\x88a8\x88V[\x81\x01``\x82\x82\x03\x12a\x01&W\x815\x91s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x80\x93\x03a\x01&W` \x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x82a+\xA4\x91\x83\x01a9\x86V[\x91`@\x82\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa+\xC3\x92\x01a9\x86V[\x90`@Q\x91\x7F3\xA8\x92\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83R` \x87\x015`\x04\x84\x01R`@`$\x84\x01R_\x83\x80a,\x0C`D\x82\x01\x86aI\xE0V[\x03\x81\x83\x88Z\xF1\x92\x83\x15a\x02\xA9W_\x93a,tW[P\x82Q` \x84\x01 \x81Q` \x83\x01 \x03a\x15JWP`\x01\x93\x92\x91\x7F\xCD\xDB2z\xDB1\xFET7\xDF*\x8Ch0\x1B\xB1:k\xAA\xE42\xA8\x04\x83\x8C\xAA\xF6\x82Pj\xAD\xF1\x91a,k`@Q\x92\x83\x92\x83aJ\x05V[\x03\x90\xA2\x01a'\xABV[\x90\x92P=\x80_\x83>a,\x86\x81\x83a4HV[\x81\x01\x90` \x81\x83\x03\x12a\x01&W\x80Q\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&W\x01\x81`\x1F\x82\x01\x12\x15a\x01&W\x80Q\x90a,\xBD\x82a94V[\x92a,\xCB`@Q\x94\x85a4HV[\x82\x84R` \x83\x83\x01\x01\x11a\x01&W\x81_\x92` \x80\x93\x01\x83\x86\x01^\x83\x01\x01R\x91_a, V[a,\xFA\x81\x84a5\xC1V[`\x04\x11a\x01&W\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0a--\x915\x16aA\xF8V[`\xA0\x8C\x01Q\x15a-?W[PPa'\x97V[a-\x88\x90` _\x81a\x16\x99s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x94\x88a5\xC1V[`@Q\x91\x81\x83\x92Q\x91\x82\x91\x01\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xA9W_Q\x90\x80;\x15a\x01&Wa-\xF2\x93_\x93`@Q\x95\x86\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R` \x8B\x015\x91`\x04\x86\x01a8dV[\x03\x91Z\xFA\x80\x15a\x02\xA9Wa.\x07W[\x80a-8V[_a.\x11\x91a4HV[\x8Aa.\x01V[Pa.\"\x8A\x80a5\xC1V[`\x04\x11a\x01&W\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0a.U\x915\x16aA\xF8V[\x85`\xA0\x82\x01Q\x15a.mW[a%\xFDa&\x08\x93a\r\xF1V[Ps\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16a.\xAF\x8B\x80a5\xC1V[` _\x81a.\xC0a\x18\r6\x8Aa7\x9CV[`@Q\x91\x81\x83\x92Q\x91\x82\x91\x01\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xA9W_Q\x92\x80;\x15a\x01&W_\x92a/,\x92`@Q\x95\x86\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R```\x04\x86\x01R`d\x85\x01\x91a8DV[\x90\x7F\x91\x9E\x13\0\x1C\xD31\x9B\xE5\xA5\xA7\xCB\x18\x92\x03\xBE\x086t\xAC\xB3\xFF\xF2=\x05\xAA\xE9\xC3\xED\x861M`$\x84\x01R`D\x83\x01R\x03\x91Z\xFA\x80\x15a\x02\xA9Wa&\x08\x93\x88\x92a%\xFD\x92a/zW[P\x93PPa.aV[_a/\x84\x91a4HV[\x8Da/qV[`\x01\x1C_[\x81\x81\x10a/\x9CWPa%&V[\x80`\x01\x1B\x90\x7F\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x81\x03a\n/Wa/\xD4\x82\x85a7{V[Q\x91`\x01\x81\x01\x80\x91\x11a\n/W`\x01\x92a\x19na/\xF1\x92\x87a7{V[a/\xFB\x82\x86a7{V[R\x01a/\x8FV[`\x01\x90\x82Q\x81\x10_\x14a0,Wa0\x19\x81\x84a7{V[Qa0$\x82\x87a7{V[R[\x01a%\x1CV[\x7F\xCC\x1D/\x83\x84E\xDBz\xECC\x1D\xF9\xEE\x8A\x87\x1F@\xE7\xAA^\x06O\xC0Vc>\xF8\xC6\x0F\xAB{\x06a0W\x82\x87a7{V[Ra0&V[a0n\x81a\r\x84` \x87\x01\x87a4\xEDV[\x90\x80`\x01\x1B\x81\x81\x04`\x02\x14\x82\x15\x17\x15a\n/W` \x83\x015a0\x90\x82\x87a7{V[R`\x01\x81\x01\x80\x91\x11a\n/Wa0\xAD`\x80`\x01\x94\x015\x91\x86a7{V[R\x01a$\x83V[` \x90a0\xBFa7*V[\x82\x82\x8B\x01\x01R\x01a\x1E\xC2V[P_\x94a\x1E\x9AV[` \x90`@Qa0\xE2\x81a3\xF3V[`@Qa0\xEE\x81a4\x0FV[_\x81R_\x84\x82\x01R_`@\x82\x01R\x81R`@Qa1\n\x81a3\xAAV[_\x81R_\x84\x82\x01R\x83\x82\x01R_`@\x82\x01R_``\x82\x01R\x82\x82\x8A\x01\x01R\x01a\x1E\x89V[_\x93a\x1EwV[\x90\x92a1I\x84a\x0C,`\x04\x805\x01\x80a4\xEDV[\x90a1Za\x1A\xDE` \x84\x01\x84a4\xEDV[\x92\x80\x91P`\x01\x1B\x90\x80\x82\x04`\x02\x14\x90\x15\x17\x15a\n/W\x80\x83\x03a\x1B\x19WP`\x01\x91a1\x84\x91a7\x8FV[\x93\x01\x90a\x1E\x17V[4a\x01&W_`\x03\x196\x01\x12a\x01&Wa1\xA4a4kV[_s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81\x16\x83U\x16\x7F\x8B\xE0\x07\x9CS\x16Y\x14\x13D\xCD\x1F\xD0\xA4\xF2\x84\x19I\x7F\x97\"\xA3\xDA\xAF\xE3\xB4\x18okdW\xE0\x82\x80\xA3\0[4a\x01&W_`\x03\x196\x01\x12a\x01&Wa2 a4kV[a2(a4\xB7V[a20a4\xB7V[t\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF_T\x16\x17_U\x7Fb\xE7\x8C\xEA\x01\xBE\xE3 \xCDNB\x02p\xB5\xEAt\0\r\x11\xB0\xC9\xF7GT\xEB\xDB\xFCTK\x05\xA2X` `@Q3\x81R\xA1\0[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\xFF_T`\xA0\x1C\x16`@Q\x90\x15\x15\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `@Qs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\x04T`@Q\x90\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\x06T`@Q\x90\x81R\xF3[4a\x01&W` `\x03\x196\x01\x12a\x01&W` a\x1C\x89`\x045a6EV[4a\x01&W_`\x03\x196\x01\x12a\x01&W\x80\x7F1.1.0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0` \x92R\xF3[\x91\x90\x82\x03\x91\x82\x11a\n/WV[`@\x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a3\xC6W`@RV[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`A`\x04R`$_\xFD[`\x80\x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a3\xC6W`@RV[``\x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a3\xC6W`@RV[a\x01 \x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a3\xC6W`@RV[\x90`\x1F`\x1F\x19\x91\x01\x16\x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a3\xC6W`@RV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF_T\x163\x03a4\x8BWV[\x7F\x11\x8C\xDA\xA7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R3`\x04R`$_\xFD[`\xFF_T`\xA0\x1C\x16a4\xC5WV[\x7F\xD9<\x06e\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04_\xFD[\x905\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE1\x816\x03\x01\x82\x12\x15a\x01&W\x01\x805\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&W` \x01\x91\x81`\x05\x1B6\x03\x83\x13a\x01&WV[\x91\x90\x81\x10\x15a\x1D\x08W`\x05\x1B\x81\x015\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xC1\x816\x03\x01\x82\x12\x15a\x01&W\x01\x90V[\x91\x90\x81\x10\x15a\x1D\x08W`\x05\x1B\x81\x015\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x01\x816\x03\x01\x82\x12\x15a\x01&W\x01\x90V[\x905\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE1\x816\x03\x01\x82\x12\x15a\x01&W\x01\x805\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&W` \x01\x91\x816\x03\x83\x13a\x01&WV[\x90` \x80\x83Q\x92\x83\x81R\x01\x92\x01\x90_[\x81\x81\x10a6/WPPP\x90V[\x82Q\x84R` \x93\x84\x01\x93\x90\x92\x01\x91`\x01\x01a6\"V[`\x04T\x81\x10\x15a\x1D\x08W`\x04_R` _ \x01\x90_\x90V[\x80T\x82\x10\x15a\x1D\x08W_R` _ \x01\x90_\x90V[`@Q\x90a6\x7F\x82a3\xAAV[_` \x83\x82\x81R\x01RV[`@Q\x90a6\x97\x82a4+V[``a\x01\0\x83\x82\x81R\x82` \x82\x01R_`@\x82\x01R`@Qa6\xB8\x81a3\xAAV[_\x81R_` \x82\x01R\x83\x82\x01R_`\x80\x82\x01R_`\xA0\x82\x01R_`\xC0\x82\x01R\x82`\xE0\x82\x01R\x01RV[g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a3\xC6W`\x05\x1B` \x01\x90V[\x90a7\x03\x82a6\xE1V[a7\x10`@Q\x91\x82a4HV[\x82\x81R`\x1F\x19a7 \x82\x94a6\xE1V[\x01\x90` 6\x91\x017V[`@Q\x90a77\x82a3\xF3V[\x81_\x81R_` \x82\x01R_`@\x82\x01R```@Q\x91a7V\x83a3\xF3V[\x81\x83R\x81` \x84\x01R\x81`@\x84\x01R\x81\x80\x84\x01R\x01RV[\x80Q\x15a\x1D\x08W` \x01\x90V[\x80Q\x82\x10\x15a\x1D\x08W` \x91`\x05\x1B\x01\x01\x90V[\x91\x90\x82\x01\x80\x92\x11a\n/WV[\x80\x92\x91\x03\x91`\xE0\x83\x12a\x01&W`@Q\x90a7\xB6\x82a3\xF3V[\x81\x93``\x81\x12a\x01&W\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xA0`@\x91\x82Qa7\xEF\x81a4\x0FV[\x845\x81R` \x85\x015` \x82\x01R\x83\x85\x015\x84\x82\x01R\x85R\x01\x12a\x01&W`\xC0``\x91`@Qa8\x1E\x81a3\xAAV[\x83\x82\x015\x81R`\x80\x82\x015` \x82\x01R` \x85\x01R`\xA0\x81\x015`@\x85\x01R\x015\x91\x01RV[`\x1F\x82` \x94\x93`\x1F\x19\x93\x81\x86R\x86\x86\x017_\x85\x82\x86\x01\x01R\x01\x16\x01\x01\x90V[\x90a8~\x90`@\x93\x96\x95\x94\x96``\x84R``\x84\x01\x91a8DV[\x94` \x82\x01R\x01RV[\x905\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x816\x03\x01\x82\x12\x15a\x01&W\x01\x90V[\x90\x82\x10\x15a\x1D\x08Wa8\xD2\x91`\x05\x1B\x81\x01\x90a8\x88V[\x90V[\x90\x92\x91\x92_[\x81\x81\x10a9\x0EW\x84\x7F\x89!\x14t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[\x84a9\x1A\x82\x84\x86a8\xBBV[5\x14a9(W`\x01\x01a8\xDBV[\x91a8\xD2\x93\x94Pa8\xBBV[g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a3\xC6W`\x1F\x01`\x1F\x19\x16` \x01\x90V[\x92\x91\x92a9\\\x82a94V[\x91a9j`@Q\x93\x84a4HV[\x82\x94\x81\x84R\x81\x83\x01\x11a\x01&W\x82\x81` \x93\x84_\x96\x017\x01\x01RV[\x90\x80`\x1F\x83\x01\x12\x15a\x01&W\x81` a8\xD2\x935\x91\x01a9PV[\x90\x80`\x1F\x83\x01\x12\x15a\x01&W\x815\x91a9\xB9\x83a6\xE1V[\x92a9\xC7`@Q\x94\x85a4HV[\x80\x84R` \x80\x85\x01\x91`\x05\x1B\x83\x01\x01\x91\x83\x83\x11a\x01&W` \x81\x01\x91[\x83\x83\x10a9\xF3WPPPPP\x90V[\x825g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x82\x01\x90`@`\x1F\x19\x83\x88\x03\x01\x12a\x01&W`@Q\x90a:\"\x82a3\xAAV[` \x83\x015`\x02\x81\x10\x15a\x01&W\x82R`@\x83\x015\x91g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x11a\x01&Wa:Y\x88` \x80\x96\x95\x81\x96\x01\x01a9\x86V[\x83\x82\x01R\x81R\x01\x92\x01\x91a9\xE4V[\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x14a\n/W`\x01\x01\x90V[\x93\x92\x90\x91a:\xA1a6\x8AV[P\x81\x94_\x93` \x82\x015\x90\x80\x82\x03aA\xCAWP`\x80\x826\x03\x12a\x01&W`@Q\x93a:\xCB\x85a3\xF3V[\x825\x94\x85\x81R\x82` \x82\x01R`@\x84\x01\x94\x855g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x85\x01\x90`\x80\x826\x03\x12a\x01&W`@Q\x91a;\x07\x83a3\xF3V[\x805g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa;%\x906\x90\x83\x01a9\xA1V[\x83R` \x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa;H\x906\x90\x83\x01a9\xA1V[` \x84\x01R`@\x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa;n\x906\x90\x83\x01a9\xA1V[`@\x84\x01R``\x81\x015\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&Wa;\x94\x916\x91\x01a9\xA1V[``\x83\x01R`@\x83\x01\x91\x82R``\x86\x01\x92\x835g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa;\xC3\x906\x90\x89\x01a9\x86V[``\x82\x01Ra;\xD0a7*V[PQ\x91Q\x90`@Q\x92a;\xE2\x84a3\xF3V[\x83R`\x01` \x84\x01R`@\x83\x01R``\x82\x01R`\xC0\x83\x01Q\x15a@\x9BWa<\x1A\x91Pa\x01\0\x83\x01Q`\x80\x84\x01Q\x91a\r\xE9\x83\x83a7{V[P[a<)a\x0F\xB9\x85\x85a8\x88V[\x90P\x86[\x81\x81\x10a>\xD0WPP\x80` a<f\x92Q\x91\x87a<P`\x80\x83\x01\x94\x85Q\x90a7{V[R\x01Q\x81Q\x91a<_\x83a:hV[\x90Ra7{V[Ra<p\x83aL\xDBV[\x15a>\xA4Wa<\x82a\x10U\x83\x83a8\x88V[\x85[\x81\x81\x10a>5WPPPa<\x9Ba\x10w\x83\x83a8\x88V[\x85[\x81\x81\x10a=\xC6WPPPa<\xB4a\x0F\xB9\x83\x83a8\x88V[\x85[\x81\x81\x10a=SWPPPa<\xCD\x91a\x10\xB9\x91a8\x88V[\x83\x92\x91\x92[\x81\x81\x10a<\xE0WPPPPPV[a<\xEB\x81\x83\x86a5AV[5`\x02\x81\x10\x15a=OW\x90`\x01\x80\x92\x14a=\x06W[\x01a<\xD2V[\x83\x7F\xA4\x94\xDA\xC4\xB7\x18HCX?\x97.\x06x>,;\xB4\x7FO\x017\xB8\xDFR\xA8`\xDF\x07!\x9F\x8Ca=6a\x11\xD9\x84\x87\x8Aa5AV[\x90a=G`@Q\x92\x83\x92\x87\x84aELV[\x03\x90\xA2a=\0V[\x85\x80\xFD[a=^\x81\x83\x85a5AV[5`\x02\x81\x10\x15a=\xC2W\x90`\x01\x80\x92\x14a=yW[\x01a<\xB6V[\x86\x7F\x9Ca\xB2\x90\xF61\t\x7FV'<\xF4\xDA\xF4\r\xF1\xFF\x9C\xCC3\xF1\x01\xD4d\x83}\xA1\xF5\xAE\x18\xBDYa=\xA9a\x11\xD9\x84\x87\x89a5AV[\x90a=\xBA`@Q\x92\x83\x92\x87\x84aELV[\x03\x90\xA2a=sV[\x87\x80\xFD[a=\xD1\x81\x83\x85a5AV[5`\x02\x81\x10\x15a=\xC2W\x90`\x01\x80\x92\x14a=\xECW[\x01a<\x9DV[\x86\x7FH$8s\xB4u-\xDC\xB4^\r{\x11\xC4\xC2fX>^\t\x9A\x0By\x8F\xDD\x9C\x1A\xF7\xD4\x93$\xF3a>\x1Ca\x11\xD9\x84\x87\x89a5AV[\x90a>-`@Q\x92\x83\x92\x87\x84aELV[\x03\x90\xA2a=\xE6V[a>@\x81\x83\x85a5AV[5`\x02\x81\x10\x15a=\xC2W\x90`\x01\x80\x92\x14a>[W[\x01a<\x84V[\x86\x7F:\x13M\x01\xC0x\x03\0<c0\x17\x17\xDD\xC4a.lG\xAE@\x8E\xEE\xA3\",\xDE\xD52\xD0*\xE6a>\x8Ba\x11\xD9\x84\x87\x89a5AV[\x90a>\x9C`@Q\x92\x83\x92\x87\x84aELV[\x03\x90\xA2a>UV[`$\x84\x84\x7F9\xA9@\xC5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82R`\x04R\xFD[a>\xE4a\x11\xD9\x82a\x0C,a\x0F\xB9\x8A\x8Aa8\x88V[\x81\x01\x90``\x81\x83\x03\x12a@\x97W\x805\x91s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x80\x93\x03a@\x93W` \x82\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a@\x8FW\x81a?2\x91\x84\x01a9\x86V[\x91`@\x81\x015\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a@\x80Wa?S\x92\x91\x01a9\x86V[\x90`@Q\x91\x7F3\xA8\x92\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83R\x87`\x04\x84\x01R`@`$\x84\x01R\x8B\x83\x80a?\x98`D\x82\x01\x86aI\xE0V[\x03\x81\x83\x88Z\xF1\x92\x83\x15a@\x84W\x8C\x93a@\0W[P\x82Q` \x84\x01 \x81Q` \x83\x01 \x03a\x15JWP`\x01\x93\x92\x91\x7F\xCD\xDB2z\xDB1\xFET7\xDF*\x8Ch0\x1B\xB1:k\xAA\xE42\xA8\x04\x83\x8C\xAA\xF6\x82Pj\xAD\xF1\x91a?\xF7`@Q\x92\x83\x92\x83aJ\x05V[\x03\x90\xA2\x01a<-V[\x90\x92P=\x80\x8D\x83>a@\x12\x81\x83a4HV[\x81\x01\x90` \x81\x83\x03\x12a@\x80W\x80Q\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a@|W\x01\x81`\x1F\x82\x01\x12\x15a@\x80W\x80Q\x90a@I\x82a94V[\x92a@W`@Q\x94\x85a4HV[\x82\x84R` \x83\x83\x01\x01\x11a@|W\x81\x8E\x92` \x80\x93\x01\x83\x86\x01^\x83\x01\x01R\x91_a?\xACV[\x8D\x80\xFD[\x8C\x80\xFD[`@Q=\x8E\x82>=\x90\xFD[\x8B\x80\xFD[\x8A\x80\xFD[\x89\x80\xFD[a@\xA5\x82\x86a5\xC1V[`\x04\x11a\x01&W\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0a@\xD8\x915\x16aA\xF8V[`\xA0\x83\x01Q\x15a@\xEAW[PPa<\x1CV[aA;\x90` _\x81aA3s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x96\x8Aa5\xC1V[\x95\x90\x94aB\xD6V[`@Q\x91\x81\x83\x92Q\x91\x82\x91\x01\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xA9W_Q\x92\x80;\x15a\x01&W_\x92\x86\x92aA\xA0`@Q\x96\x87\x95\x86\x94\x85\x94\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x86R`\x04\x86\x01a8dV[\x03\x91Z\xFA\x80\x15a\x02\xA9WaA\xB5W[\x80a@\xE3V[aA\xC2\x91\x96P_\x90a4HV[_\x94_aA\xAFV[\x7F\x18\xF69\xD8\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$R`D_\xFD[\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x80\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x91\x16\x90\x80\x82\x03aBJWPPV[\x7Fx\xA2\"\x1C\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$R`D_\xFD[\x80Q\x80Q\x91`@` \x83\x01Q\x92\x01Q` \x82\x01Q` \x81Q\x91\x01Q\x91```@\x85\x01Q\x94\x01Q\x94`@Q\x96` \x88\x01R`@\x87\x01R``\x86\x01R`\x80\x85\x01R`\xA0\x84\x01R`\xC0\x83\x01R`\xE0\x82\x01R`\xE0\x81Ra8\xD2a\x01\0\x82a4HV[``\x81\x01Q\x81Q` \x83\x01Q\x90\x91\x90\x15aECW`@c\x01\0\0\0\x93[\x01Q\x90\x80Q\x90\x81Qc\xFF\xFF\xFF\xFF\x16aC-\x90b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x91aC7\x90aHlV[` \x82\x01Q\x80Qc\xFF\xFF\xFF\xFF\x16aCp\x90b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x90aCz\x90aHlV[\x90`@\x84\x01Q\x92\x83Qc\xFF\xFF\xFF\xFF\x16aC\xB5\x90b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x93aC\xBF\x90aHlV[\x94``\x01Q\x95\x86Qc\xFF\xFF\xFF\xFF\x16aC\xF9\x90b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x96aD\x03\x90aHlV[\x97`@Q\x9A\x8B\x9A` \x8C\x01R`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`@\x8B\x01R`D\x8A\x01R`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`d\x89\x01R\x80Q` \x81\x92\x01`h\x8A\x01^\x87\x01\x90`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`h\x82\x01R\x81Q` \x81\x93\x01`l\x83\x01^\x01`h\x01\x90`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`\x04\x82\x01R\x81Q` \x81\x93\x01`\x08\x83\x01^\x01`\x04\x01\x90`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`\x04\x82\x01R\x81Q` \x81\x93\x01`\x08\x83\x01^\x01`\x04\x01`\x04\x81\x01_\x90R\x03`\x04\x01`\x1F\x19\x81\x01\x82Ra8\xD2\x90\x82a4HV[`@_\x93aB\xF3V[`@\x90a8\xD2\x94\x92\x81R\x81` \x82\x01R\x01\x91a8DV[\x80\x15\x80\x15aE\xB5W[\x80\x15aE\xADW[\x80\x15aE\x9DW[aE\x97Wd\x01\0\0\x03\xD0\x19`\x07\x81\x80\x93\x81\x81\x80\t\t\x08\x91\x80\t\x14\x90V[PP_\x90V[Pd\x01\0\0\x03\xD0\x19\x82\x10\x15aEzV[P\x81\x15aEsV[Pd\x01\0\0\x03\xD0\x19\x81\x10\x15aElV[\x90\x93\x92\x90\x91_\x90\x80\x84\x03aH\rWPPd\x01\0\0\x03\xD0\x19_\x91\x85\x08aE\xEEWPP\x90P_\x90_\x90V[d\x01\0\0\x03\xD0\x19\x80`\x01\x81\x80aFU\x81\x80\x80aFE\x9A\x81\x80\x8F\x80\t\x96\x87\x92\x81\x80\x80\x80\x80\x8F\x81\x81\x81\x92\t\x99\x87\t`\x04\t\x97\x80\t_\t\x92\x80\t`\x03\t\x08\x91\x81aF8\x81\x83\x80\x08\x82a3\x9DV[\x81\x85\x80\t\x08\x9D\x8E\x83a3\x9DV[\x90\x08\x90\t\x93\x80\t`\x08\t\x83a3\x9DV[\x90\x08\x96\t`\x02\t\x93\x91\x90[\x84\x15\x15\x85\x81aG\xFCW[P\x80aG\xF4W[\x15aG\x96W\x80\x94\x80`\x01d\x01\0\0\x03\xD0\x19\x84\x92[aF\xD9WPPPP\x80aF\xACWP\x90d\x01\0\0\x03\xD0\x19\x80\x92\x81\x80\x87\x80\t\x80\x92\t\x95\t\x90\t\x90V[\x80\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`$\x92R`\x12`\x04R\xFD[\x92\x97\x91\x92\x88\x15aGiW\x88\x81\x04\x91\x80\x94aG<Wd\x01\0\0\x03\xD0\x19\x90\x83\td\x01\0\0\x03\xD0\x19\x03d\x01\0\0\x03\xD0\x19\x81\x11a\n/Wd\x01\0\0\x03\xD0\x19\x90\x86\x94\x08\x93\x98\x80\x92\x81\x81\x02\x91\x81\x83\x04\x14\x90\x15\x17\x15a\n/WaG4\x91a3\x9DV[\x92\x90\x83aF\x85V[`$\x86\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x12`\x04R\xFD[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x12`\x04R`$_\xFD[`d`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x0E`$\x82\x01R\x7FInvalid number\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R\xFD[P`\x01aFqV[d\x01\0\0\x03\xD0\x19\x91P\x14\x15_aFjV[d\x01\0\0\x03\xD0\x19\x92\x91\x95aH \x94aJ\xA7V[\x93\x90\x91\x90aF`V[_\x90` \x92`@Q\x90\x84\x82\x01\x92\x83R`@\x82\x01R`@\x81RaHL``\x82a4HV[`@Q\x91\x82\x91Q\x80\x91\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xA9W_Q\x90V[\x80Q``\x92\x91_\x91[\x80\x83\x10aH\x81WPPPV[\x90\x91\x93aH\xC8c\xFF\xFF\xFF\xFF` aH\x98\x88\x87a7{V[Q\x01QQ`\x02\x1C\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x90` aH\xD5\x87\x86a7{V[Q\x01QaH\xE2\x87\x86a7{V[QQ`\x02\x81\x10\x15aI\xB3W`\x04` \x93aI\xAA\x93\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x86\x80`\x01\x99aII\x87\x98b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x94\x84`@Q\x9B\x88\x8D\x99Q\x91\x82\x91\x01\x86\x8B\x01^\x88\x01\x92`\xE0\x1B\x16\x83\x83\x01R\x80Q\x92\x83\x91\x01`$\x83\x01^\x01\x01\x91`\xE0\x1B\x16\x83\x82\x01R\x03\x01\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE4\x81\x01\x84R\x01\x82a4HV[\x94\x01\x91\x90aHuV[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`!`\x04R`$_\xFD[\x90`\x1F\x19`\x1F` \x80\x94\x80Q\x91\x82\x91\x82\x87R\x01\x86\x86\x01^_\x85\x82\x86\x01\x01R\x01\x16\x01\x01\x90V[\x90\x91aJ\x1Ca8\xD2\x93`@\x84R`@\x84\x01\x90aI\xE0V[\x91` \x81\x84\x03\x91\x01RaI\xE0V[`\x02Th\x01\0\0\0\0\0\0\0\0\x81\x10\x15a3\xC6W\x80`\x01aJP\x92\x01`\x02U`\x02a6]V[\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x93\x92T\x91`\x03\x1B\x92\x83\x1B\x92\x1B\x19\x16\x17\x90UV[\x80Th\x01\0\0\0\0\0\0\0\0\x81\x10\x15a3\xC6WaJP\x91`\x01\x82\x01\x81Ua6]V[\x94\x92\x91\x85\x15\x80aL\x9AW[aL\x8EW\x80\x15\x80aL\x86W[aL|W`@Q`\x80\x91aJ\xD2\x83\x83a4HV[\x826\x837\x86\x15aGiW\x86\x94\x85\x80\x92\x81\x80`\x01\x80\t\x80\x87R\x97\x81\x89`\x01\t\x9C` \x88\x01\x9D\x8ER\x82`@\x89\x01\x9D\x8E\x8C\x81RQ`\x01\t\x91``\x8A\x01\x92\x83R`@Q\x9E\x8FaK\x1C\x90a3\xF3V[Q\x90\t\x8DRQ\x90\t\x94` \x8B\x01\x95\x86RQ\x90\t\x98`@\x89\x01\x99\x8ARQ\x90\t``\x87\x01\x90\x81R\x86Q\x88Q\x14\x80\x15\x90aLpW[\x15aL\x12W\x84\x92\x83\x80\x80\x93\x81`@Q\x9C\x85aKj\x8F\x97\x88a4HV[6\x877Q\x8CQaKz\x90\x83a3\x9DV[\x90\x08\x84RQ\x85QaK\x8B\x90\x83a3\x9DV[\x90\x08\x98` \x83\x01\x99\x8AR\x81\x80\x8B\x81\x80\x80\x80\x89Q\x8AQ\x90\t\x93`@\x8A\x01\x94\x85R\x81\x85Q\x8BQ\x90\t``\x90\x9A\x01\x99\x8ARQ\x80\t\x88QaK\xC8\x90\x83a3\x9DV[\x90\x08\x81\x80\x87Q\x85Q\x90\t`\x02\taK\xDF\x90\x83a3\x9DV[\x90\x08\x9CQ\x93Q\x90Q\x90\taK\xF3\x8C\x83a3\x9DV[\x90\x08\x90\t\x92Q\x90Q\x90\taL\x07\x90\x83a3\x9DV[\x90\x08\x94Q\t\x91\x92\x91\x90V[`d`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x1E`$\x82\x01R\x7FUse jacDouble function instead\0\0`D\x82\x01R\xFD[P\x81Q\x81Q\x14\x15aKNV[P\x92P`\x01\x91\x90PV[P\x82\x15aJ\xBEV[\x94P\x90\x92P`\x01\x91\x90PV[P\x81\x15aJ\xB2V[\x80_R`\x05` R`@_ T\x15_\x14aL\xD6WaL\xC1\x81`\x04aJ\x85V[`\x04T\x90_R`\x05` R`@_ U`\x01\x90V[P_\x90V[\x80_R`\x07` R`@_ T\x15_\x14aL\xD6WaL\xFA\x81`\x06aJ\x85V[`\x06T\x90_R`\x07` R`@_ U`\x01\x90V[`\x04\x11\x15aI\xB3WV[\x81Q\x91\x90`A\x83\x03aMIWaMB\x92P` \x82\x01Q\x90```@\x84\x01Q\x93\x01Q_\x1A\x90aN\x1AV[\x91\x92\x90\x91\x90V[PP_\x91`\x02\x91\x90V[aM\\\x81aM\x0FV[\x80aMeWPPV[aMn\x81aM\x0FV[`\x01\x81\x03aM\x9EW\x7F\xF6E\xEE\xDF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04_\xFD[aM\xA7\x81aM\x0FV[`\x02\x81\x03aM\xDBWP\x7F\xFC\xE6\x98\xF7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[`\x03\x90aM\xE7\x81aM\x0FV[\x14aM\xEFWPV[\x7F\xD7\x8B\xCE\x0C\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[\x91\x90\x7F\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF]WnsW\xA4P\x1D\xDF\xE9/Fh\x1B \xA0\x84\x11aN\x9EW\x91` \x93`\x80\x92`\xFF_\x95`@Q\x94\x85R\x16\x86\x84\x01R`@\x83\x01R``\x82\x01R\x82\x80R`\x01Z\xFA\x15a\x02\xA9W_Qs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x15aN\x94W\x90_\x90_\x90V[P_\x90`\x01\x90_\x90V[PPP_\x91`\x03\x91\x90V",
    );
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive()]
    /**```solidity
struct Action { Logic.VerifierInput[] logicVerifierInputs; Compliance.VerifierInput[] complianceVerifierInputs; }
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct Action {
        #[allow(missing_docs)]
        pub logicVerifierInputs: alloy::sol_types::private::Vec<
            <Logic::VerifierInput as alloy::sol_types::SolType>::RustType,
        >,
        #[allow(missing_docs)]
        pub complianceVerifierInputs: alloy::sol_types::private::Vec<
            <Compliance::VerifierInput as alloy::sol_types::SolType>::RustType,
        >,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (
            alloy::sol_types::sol_data::Array<Logic::VerifierInput>,
            alloy::sol_types::sol_data::Array<Compliance::VerifierInput>,
        );
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (
            alloy::sol_types::private::Vec<
                <Logic::VerifierInput as alloy::sol_types::SolType>::RustType,
            >,
            alloy::sol_types::private::Vec<
                <Compliance::VerifierInput as alloy::sol_types::SolType>::RustType,
            >,
        );
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<Action> for UnderlyingRustTuple<'_> {
            fn from(value: Action) -> Self {
                (value.logicVerifierInputs, value.complianceVerifierInputs)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for Action {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self {
                    logicVerifierInputs: tuple.0,
                    complianceVerifierInputs: tuple.1,
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolValue for Action {
            type SolType = Self;
        }
        #[automatically_derived]
        impl alloy_sol_types::private::SolTypeValue<Self> for Action {
            #[inline]
            fn stv_to_tokens(&self) -> <Self as alloy_sol_types::SolType>::Token<'_> {
                (
                    <alloy::sol_types::sol_data::Array<
                        Logic::VerifierInput,
                    > as alloy_sol_types::SolType>::tokenize(&self.logicVerifierInputs),
                    <alloy::sol_types::sol_data::Array<
                        Compliance::VerifierInput,
                    > as alloy_sol_types::SolType>::tokenize(
                        &self.complianceVerifierInputs,
                    ),
                )
            }
            #[inline]
            fn stv_abi_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encoded_size(&tuple)
            }
            #[inline]
            fn stv_eip712_data_word(&self) -> alloy_sol_types::Word {
                <Self as alloy_sol_types::SolStruct>::eip712_hash_struct(self)
            }
            #[inline]
            fn stv_abi_encode_packed_to(
                &self,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encode_packed_to(&tuple, out)
            }
            #[inline]
            fn stv_abi_packed_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_packed_encoded_size(&tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolType for Action {
            type RustType = Self;
            type Token<'a> = <UnderlyingSolTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SOL_NAME: &'static str = <Self as alloy_sol_types::SolStruct>::NAME;
            const ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::ENCODED_SIZE;
            const PACKED_ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE;
            #[inline]
            fn valid_token(token: &Self::Token<'_>) -> bool {
                <UnderlyingSolTuple<'_> as alloy_sol_types::SolType>::valid_token(token)
            }
            #[inline]
            fn detokenize(token: Self::Token<'_>) -> Self::RustType {
                let tuple = <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::detokenize(token);
                <Self as ::core::convert::From<UnderlyingRustTuple<'_>>>::from(tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolStruct for Action {
            const NAME: &'static str = "Action";
            #[inline]
            fn eip712_root_type() -> alloy_sol_types::private::Cow<'static, str> {
                alloy_sol_types::private::Cow::Borrowed(
                    "Action(Logic.VerifierInput[] logicVerifierInputs,Compliance.VerifierInput[] complianceVerifierInputs)",
                )
            }
            #[inline]
            fn eip712_components() -> alloy_sol_types::private::Vec<
                alloy_sol_types::private::Cow<'static, str>,
            > {
                let mut components = alloy_sol_types::private::Vec::with_capacity(2);
                components
                    .push(
                        <Logic::VerifierInput as alloy_sol_types::SolStruct>::eip712_root_type(),
                    );
                components
                    .extend(
                        <Logic::VerifierInput as alloy_sol_types::SolStruct>::eip712_components(),
                    );
                components
                    .push(
                        <Compliance::VerifierInput as alloy_sol_types::SolStruct>::eip712_root_type(),
                    );
                components
                    .extend(
                        <Compliance::VerifierInput as alloy_sol_types::SolStruct>::eip712_components(),
                    );
                components
            }
            #[inline]
            fn eip712_encode_data(&self) -> alloy_sol_types::private::Vec<u8> {
                [
                    <alloy::sol_types::sol_data::Array<
                        Logic::VerifierInput,
                    > as alloy_sol_types::SolType>::eip712_data_word(
                            &self.logicVerifierInputs,
                        )
                        .0,
                    <alloy::sol_types::sol_data::Array<
                        Compliance::VerifierInput,
                    > as alloy_sol_types::SolType>::eip712_data_word(
                            &self.complianceVerifierInputs,
                        )
                        .0,
                ]
                    .concat()
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::EventTopic for Action {
            #[inline]
            fn topic_preimage_length(rust: &Self::RustType) -> usize {
                0usize
                    + <alloy::sol_types::sol_data::Array<
                        Logic::VerifierInput,
                    > as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.logicVerifierInputs,
                    )
                    + <alloy::sol_types::sol_data::Array<
                        Compliance::VerifierInput,
                    > as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.complianceVerifierInputs,
                    )
            }
            #[inline]
            fn encode_topic_preimage(
                rust: &Self::RustType,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                out.reserve(
                    <Self as alloy_sol_types::EventTopic>::topic_preimage_length(rust),
                );
                <alloy::sol_types::sol_data::Array<
                    Logic::VerifierInput,
                > as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.logicVerifierInputs,
                    out,
                );
                <alloy::sol_types::sol_data::Array<
                    Compliance::VerifierInput,
                > as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.complianceVerifierInputs,
                    out,
                );
            }
            #[inline]
            fn encode_topic(
                rust: &Self::RustType,
            ) -> alloy_sol_types::abi::token::WordToken {
                let mut out = alloy_sol_types::private::Vec::new();
                <Self as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    rust,
                    &mut out,
                );
                alloy_sol_types::abi::token::WordToken(
                    alloy_sol_types::private::keccak256(out),
                )
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive()]
    /**```solidity
struct Transaction { Action[] actions; bytes deltaProof; bytes aggregationProof; }
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct Transaction {
        #[allow(missing_docs)]
        pub actions: alloy::sol_types::private::Vec<
            <Action as alloy::sol_types::SolType>::RustType,
        >,
        #[allow(missing_docs)]
        pub deltaProof: alloy::sol_types::private::Bytes,
        #[allow(missing_docs)]
        pub aggregationProof: alloy::sol_types::private::Bytes,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (
            alloy::sol_types::sol_data::Array<Action>,
            alloy::sol_types::sol_data::Bytes,
            alloy::sol_types::sol_data::Bytes,
        );
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (
            alloy::sol_types::private::Vec<
                <Action as alloy::sol_types::SolType>::RustType,
            >,
            alloy::sol_types::private::Bytes,
            alloy::sol_types::private::Bytes,
        );
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<Transaction> for UnderlyingRustTuple<'_> {
            fn from(value: Transaction) -> Self {
                (value.actions, value.deltaProof, value.aggregationProof)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for Transaction {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self {
                    actions: tuple.0,
                    deltaProof: tuple.1,
                    aggregationProof: tuple.2,
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolValue for Transaction {
            type SolType = Self;
        }
        #[automatically_derived]
        impl alloy_sol_types::private::SolTypeValue<Self> for Transaction {
            #[inline]
            fn stv_to_tokens(&self) -> <Self as alloy_sol_types::SolType>::Token<'_> {
                (
                    <alloy::sol_types::sol_data::Array<
                        Action,
                    > as alloy_sol_types::SolType>::tokenize(&self.actions),
                    <alloy::sol_types::sol_data::Bytes as alloy_sol_types::SolType>::tokenize(
                        &self.deltaProof,
                    ),
                    <alloy::sol_types::sol_data::Bytes as alloy_sol_types::SolType>::tokenize(
                        &self.aggregationProof,
                    ),
                )
            }
            #[inline]
            fn stv_abi_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encoded_size(&tuple)
            }
            #[inline]
            fn stv_eip712_data_word(&self) -> alloy_sol_types::Word {
                <Self as alloy_sol_types::SolStruct>::eip712_hash_struct(self)
            }
            #[inline]
            fn stv_abi_encode_packed_to(
                &self,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_encode_packed_to(&tuple, out)
            }
            #[inline]
            fn stv_abi_packed_encoded_size(&self) -> usize {
                if let Some(size) = <Self as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE {
                    return size;
                }
                let tuple = <UnderlyingRustTuple<
                    '_,
                > as ::core::convert::From<Self>>::from(self.clone());
                <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_packed_encoded_size(&tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolType for Transaction {
            type RustType = Self;
            type Token<'a> = <UnderlyingSolTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SOL_NAME: &'static str = <Self as alloy_sol_types::SolStruct>::NAME;
            const ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::ENCODED_SIZE;
            const PACKED_ENCODED_SIZE: Option<usize> = <UnderlyingSolTuple<
                '_,
            > as alloy_sol_types::SolType>::PACKED_ENCODED_SIZE;
            #[inline]
            fn valid_token(token: &Self::Token<'_>) -> bool {
                <UnderlyingSolTuple<'_> as alloy_sol_types::SolType>::valid_token(token)
            }
            #[inline]
            fn detokenize(token: Self::Token<'_>) -> Self::RustType {
                let tuple = <UnderlyingSolTuple<
                    '_,
                > as alloy_sol_types::SolType>::detokenize(token);
                <Self as ::core::convert::From<UnderlyingRustTuple<'_>>>::from(tuple)
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolStruct for Transaction {
            const NAME: &'static str = "Transaction";
            #[inline]
            fn eip712_root_type() -> alloy_sol_types::private::Cow<'static, str> {
                alloy_sol_types::private::Cow::Borrowed(
                    "Transaction(Action[] actions,bytes deltaProof,bytes aggregationProof)",
                )
            }
            #[inline]
            fn eip712_components() -> alloy_sol_types::private::Vec<
                alloy_sol_types::private::Cow<'static, str>,
            > {
                let mut components = alloy_sol_types::private::Vec::with_capacity(1);
                components
                    .push(<Action as alloy_sol_types::SolStruct>::eip712_root_type());
                components
                    .extend(<Action as alloy_sol_types::SolStruct>::eip712_components());
                components
            }
            #[inline]
            fn eip712_encode_data(&self) -> alloy_sol_types::private::Vec<u8> {
                [
                    <alloy::sol_types::sol_data::Array<
                        Action,
                    > as alloy_sol_types::SolType>::eip712_data_word(&self.actions)
                        .0,
                    <alloy::sol_types::sol_data::Bytes as alloy_sol_types::SolType>::eip712_data_word(
                            &self.deltaProof,
                        )
                        .0,
                    <alloy::sol_types::sol_data::Bytes as alloy_sol_types::SolType>::eip712_data_word(
                            &self.aggregationProof,
                        )
                        .0,
                ]
                    .concat()
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::EventTopic for Transaction {
            #[inline]
            fn topic_preimage_length(rust: &Self::RustType) -> usize {
                0usize
                    + <alloy::sol_types::sol_data::Array<
                        Action,
                    > as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.actions,
                    )
                    + <alloy::sol_types::sol_data::Bytes as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.deltaProof,
                    )
                    + <alloy::sol_types::sol_data::Bytes as alloy_sol_types::EventTopic>::topic_preimage_length(
                        &rust.aggregationProof,
                    )
            }
            #[inline]
            fn encode_topic_preimage(
                rust: &Self::RustType,
                out: &mut alloy_sol_types::private::Vec<u8>,
            ) {
                out.reserve(
                    <Self as alloy_sol_types::EventTopic>::topic_preimage_length(rust),
                );
                <alloy::sol_types::sol_data::Array<
                    Action,
                > as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.actions,
                    out,
                );
                <alloy::sol_types::sol_data::Bytes as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.deltaProof,
                    out,
                );
                <alloy::sol_types::sol_data::Bytes as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    &rust.aggregationProof,
                    out,
                );
            }
            #[inline]
            fn encode_topic(
                rust: &Self::RustType,
            ) -> alloy_sol_types::abi::token::WordToken {
                let mut out = alloy_sol_types::private::Vec::new();
                <Self as alloy_sol_types::EventTopic>::encode_topic_preimage(
                    rust,
                    &mut out,
                );
                alloy_sol_types::abi::token::WordToken(
                    alloy_sol_types::private::keccak256(out),
                )
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `DeltaMismatch(address,address)` and selector `0xe6d44b4c`.
```solidity
error DeltaMismatch(address expected, address actual);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct DeltaMismatch {
        #[allow(missing_docs)]
        pub expected: alloy::sol_types::private::Address,
        #[allow(missing_docs)]
        pub actual: alloy::sol_types::private::Address,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (
            alloy::sol_types::sol_data::Address,
            alloy::sol_types::sol_data::Address,
        );
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (
            alloy::sol_types::private::Address,
            alloy::sol_types::private::Address,
        );
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<DeltaMismatch> for UnderlyingRustTuple<'_> {
            fn from(value: DeltaMismatch) -> Self {
                (value.expected, value.actual)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for DeltaMismatch {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self {
                    expected: tuple.0,
                    actual: tuple.1,
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for DeltaMismatch {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "DeltaMismatch(address,address)";
            const SELECTOR: [u8; 4] = [230u8, 212u8, 75u8, 76u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::Address as alloy_sol_types::SolType>::tokenize(
                        &self.expected,
                    ),
                    <alloy::sol_types::sol_data::Address as alloy_sol_types::SolType>::tokenize(
                        &self.actual,
                    ),
                )
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `ECDSAInvalidSignature()` and selector `0xf645eedf`.
```solidity
error ECDSAInvalidSignature();
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct ECDSAInvalidSignature;
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = ();
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = ();
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<ECDSAInvalidSignature> for UnderlyingRustTuple<'_> {
            fn from(value: ECDSAInvalidSignature) -> Self {
                ()
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for ECDSAInvalidSignature {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for ECDSAInvalidSignature {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "ECDSAInvalidSignature()";
            const SELECTOR: [u8; 4] = [246u8, 69u8, 238u8, 223u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `ECDSAInvalidSignatureLength(uint256)` and selector `0xfce698f7`.
```solidity
error ECDSAInvalidSignatureLength(uint256 length);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct ECDSAInvalidSignatureLength {
        #[allow(missing_docs)]
        pub length: alloy::sol_types::private::primitives::aliases::U256,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::Uint<256>,);
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (
            alloy::sol_types::private::primitives::aliases::U256,
        );
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<ECDSAInvalidSignatureLength>
        for UnderlyingRustTuple<'_> {
            fn from(value: ECDSAInvalidSignatureLength) -> Self {
                (value.length,)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>>
        for ECDSAInvalidSignatureLength {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self { length: tuple.0 }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for ECDSAInvalidSignatureLength {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "ECDSAInvalidSignatureLength(uint256)";
            const SELECTOR: [u8; 4] = [252u8, 230u8, 152u8, 247u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::SolType>::tokenize(&self.length),
                )
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `ECDSAInvalidSignatureS(bytes32)` and selector `0xd78bce0c`.
```solidity
error ECDSAInvalidSignatureS(bytes32 s);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct ECDSAInvalidSignatureS {
        #[allow(missing_docs)]
        pub s: alloy::sol_types::private::FixedBytes<32>,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::FixedBytes<32>,);
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (alloy::sol_types::private::FixedBytes<32>,);
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<ECDSAInvalidSignatureS> for UnderlyingRustTuple<'_> {
            fn from(value: ECDSAInvalidSignatureS) -> Self {
                (value.s,)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for ECDSAInvalidSignatureS {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self { s: tuple.0 }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for ECDSAInvalidSignatureS {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "ECDSAInvalidSignatureS(bytes32)";
            const SELECTOR: [u8; 4] = [215u8, 139u8, 206u8, 12u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.s),
                )
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `EnforcedPause()` and selector `0xd93c0665`.
```solidity
error EnforcedPause();
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct EnforcedPause;
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = ();
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = ();
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<EnforcedPause> for UnderlyingRustTuple<'_> {
            fn from(value: EnforcedPause) -> Self {
                ()
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for EnforcedPause {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for EnforcedPause {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "EnforcedPause()";
            const SELECTOR: [u8; 4] = [217u8, 60u8, 6u8, 101u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `ExpectedPause()` and selector `0x8dfc202b`.
```solidity
error ExpectedPause();
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct ExpectedPause;
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = ();
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = ();
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<ExpectedPause> for UnderlyingRustTuple<'_> {
            fn from(value: ExpectedPause) -> Self {
                ()
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for ExpectedPause {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for ExpectedPause {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "ExpectedPause()";
            const SELECTOR: [u8; 4] = [141u8, 252u8, 32u8, 43u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `ForwarderCallOutputMismatch(bytes,bytes)` and selector `0xc504fada`.
```solidity
error ForwarderCallOutputMismatch(bytes expected, bytes actual);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct ForwarderCallOutputMismatch {
        #[allow(missing_docs)]
        pub expected: alloy::sol_types::private::Bytes,
        #[allow(missing_docs)]
        pub actual: alloy::sol_types::private::Bytes,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (
            alloy::sol_types::sol_data::Bytes,
            alloy::sol_types::sol_data::Bytes,
        );
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (
            alloy::sol_types::private::Bytes,
            alloy::sol_types::private::Bytes,
        );
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<ForwarderCallOutputMismatch>
        for UnderlyingRustTuple<'_> {
            fn from(value: ForwarderCallOutputMismatch) -> Self {
                (value.expected, value.actual)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>>
        for ForwarderCallOutputMismatch {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self {
                    expected: tuple.0,
                    actual: tuple.1,
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for ForwarderCallOutputMismatch {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "ForwarderCallOutputMismatch(bytes,bytes)";
            const SELECTOR: [u8; 4] = [197u8, 4u8, 250u8, 218u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::Bytes as alloy_sol_types::SolType>::tokenize(
                        &self.expected,
                    ),
                    <alloy::sol_types::sol_data::Bytes as alloy_sol_types::SolType>::tokenize(
                        &self.actual,
                    ),
                )
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `LogicRefMismatch(bytes32,bytes32)` and selector `0x18f639d8`.
```solidity
error LogicRefMismatch(bytes32 expected, bytes32 actual);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct LogicRefMismatch {
        #[allow(missing_docs)]
        pub expected: alloy::sol_types::private::FixedBytes<32>,
        #[allow(missing_docs)]
        pub actual: alloy::sol_types::private::FixedBytes<32>,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (
            alloy::sol_types::sol_data::FixedBytes<32>,
            alloy::sol_types::sol_data::FixedBytes<32>,
        );
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (
            alloy::sol_types::private::FixedBytes<32>,
            alloy::sol_types::private::FixedBytes<32>,
        );
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<LogicRefMismatch> for UnderlyingRustTuple<'_> {
            fn from(value: LogicRefMismatch) -> Self {
                (value.expected, value.actual)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for LogicRefMismatch {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self {
                    expected: tuple.0,
                    actual: tuple.1,
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for LogicRefMismatch {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "LogicRefMismatch(bytes32,bytes32)";
            const SELECTOR: [u8; 4] = [24u8, 246u8, 57u8, 216u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.expected),
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.actual),
                )
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `NonExistingRoot(bytes32)` and selector `0xf9849ea3`.
```solidity
error NonExistingRoot(bytes32 root);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct NonExistingRoot {
        #[allow(missing_docs)]
        pub root: alloy::sol_types::private::FixedBytes<32>,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::FixedBytes<32>,);
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (alloy::sol_types::private::FixedBytes<32>,);
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<NonExistingRoot> for UnderlyingRustTuple<'_> {
            fn from(value: NonExistingRoot) -> Self {
                (value.root,)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for NonExistingRoot {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self { root: tuple.0 }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for NonExistingRoot {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "NonExistingRoot(bytes32)";
            const SELECTOR: [u8; 4] = [249u8, 132u8, 158u8, 163u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.root),
                )
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `OwnableInvalidOwner(address)` and selector `0x1e4fbdf7`.
```solidity
error OwnableInvalidOwner(address owner);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct OwnableInvalidOwner {
        #[allow(missing_docs)]
        pub owner: alloy::sol_types::private::Address,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::Address,);
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (alloy::sol_types::private::Address,);
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<OwnableInvalidOwner> for UnderlyingRustTuple<'_> {
            fn from(value: OwnableInvalidOwner) -> Self {
                (value.owner,)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for OwnableInvalidOwner {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self { owner: tuple.0 }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for OwnableInvalidOwner {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "OwnableInvalidOwner(address)";
            const SELECTOR: [u8; 4] = [30u8, 79u8, 189u8, 247u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::Address as alloy_sol_types::SolType>::tokenize(
                        &self.owner,
                    ),
                )
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `OwnableUnauthorizedAccount(address)` and selector `0x118cdaa7`.
```solidity
error OwnableUnauthorizedAccount(address account);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct OwnableUnauthorizedAccount {
        #[allow(missing_docs)]
        pub account: alloy::sol_types::private::Address,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::Address,);
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (alloy::sol_types::private::Address,);
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<OwnableUnauthorizedAccount>
        for UnderlyingRustTuple<'_> {
            fn from(value: OwnableUnauthorizedAccount) -> Self {
                (value.account,)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>>
        for OwnableUnauthorizedAccount {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self { account: tuple.0 }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for OwnableUnauthorizedAccount {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "OwnableUnauthorizedAccount(address)";
            const SELECTOR: [u8; 4] = [17u8, 140u8, 218u8, 167u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::Address as alloy_sol_types::SolType>::tokenize(
                        &self.account,
                    ),
                )
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `PointNotOnCurve((uint256,uint256))` and selector `0xb8a0e8a1`.
```solidity
error PointNotOnCurve(Delta.Point point);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct PointNotOnCurve {
        #[allow(missing_docs)]
        pub point: <Delta::Point as alloy::sol_types::SolType>::RustType,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (Delta::Point,);
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (
            <Delta::Point as alloy::sol_types::SolType>::RustType,
        );
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<PointNotOnCurve> for UnderlyingRustTuple<'_> {
            fn from(value: PointNotOnCurve) -> Self {
                (value.point,)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for PointNotOnCurve {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self { point: tuple.0 }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for PointNotOnCurve {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "PointNotOnCurve((uint256,uint256))";
            const SELECTOR: [u8; 4] = [184u8, 160u8, 232u8, 161u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (<Delta::Point as alloy_sol_types::SolType>::tokenize(&self.point),)
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `PreExistingNullifier(bytes32)` and selector `0x39a940c5`.
```solidity
error PreExistingNullifier(bytes32 nullifier);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct PreExistingNullifier {
        #[allow(missing_docs)]
        pub nullifier: alloy::sol_types::private::FixedBytes<32>,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::FixedBytes<32>,);
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (alloy::sol_types::private::FixedBytes<32>,);
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<PreExistingNullifier> for UnderlyingRustTuple<'_> {
            fn from(value: PreExistingNullifier) -> Self {
                (value.nullifier,)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for PreExistingNullifier {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self { nullifier: tuple.0 }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for PreExistingNullifier {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "PreExistingNullifier(bytes32)";
            const SELECTOR: [u8; 4] = [57u8, 169u8, 64u8, 197u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.nullifier),
                )
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `PreExistingRoot(bytes32)` and selector `0xdb788c2b`.
```solidity
error PreExistingRoot(bytes32 root);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct PreExistingRoot {
        #[allow(missing_docs)]
        pub root: alloy::sol_types::private::FixedBytes<32>,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::FixedBytes<32>,);
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (alloy::sol_types::private::FixedBytes<32>,);
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<PreExistingRoot> for UnderlyingRustTuple<'_> {
            fn from(value: PreExistingRoot) -> Self {
                (value.root,)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for PreExistingRoot {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self { root: tuple.0 }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for PreExistingRoot {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "PreExistingRoot(bytes32)";
            const SELECTOR: [u8; 4] = [219u8, 120u8, 140u8, 43u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.root),
                )
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `ReentrancyGuardReentrantCall()` and selector `0x3ee5aeb5`.
```solidity
error ReentrancyGuardReentrantCall();
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct ReentrancyGuardReentrantCall;
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = ();
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = ();
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<ReentrancyGuardReentrantCall>
        for UnderlyingRustTuple<'_> {
            fn from(value: ReentrancyGuardReentrantCall) -> Self {
                ()
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>>
        for ReentrancyGuardReentrantCall {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for ReentrancyGuardReentrantCall {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "ReentrancyGuardReentrantCall()";
            const SELECTOR: [u8; 4] = [62u8, 229u8, 174u8, 181u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `RiscZeroVerifierSelectorMismatch(bytes4,bytes4)` and selector `0x78a2221c`.
```solidity
error RiscZeroVerifierSelectorMismatch(bytes4 expected, bytes4 actual);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct RiscZeroVerifierSelectorMismatch {
        #[allow(missing_docs)]
        pub expected: alloy::sol_types::private::FixedBytes<4>,
        #[allow(missing_docs)]
        pub actual: alloy::sol_types::private::FixedBytes<4>,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (
            alloy::sol_types::sol_data::FixedBytes<4>,
            alloy::sol_types::sol_data::FixedBytes<4>,
        );
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (
            alloy::sol_types::private::FixedBytes<4>,
            alloy::sol_types::private::FixedBytes<4>,
        );
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<RiscZeroVerifierSelectorMismatch>
        for UnderlyingRustTuple<'_> {
            fn from(value: RiscZeroVerifierSelectorMismatch) -> Self {
                (value.expected, value.actual)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>>
        for RiscZeroVerifierSelectorMismatch {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self {
                    expected: tuple.0,
                    actual: tuple.1,
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for RiscZeroVerifierSelectorMismatch {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "RiscZeroVerifierSelectorMismatch(bytes4,bytes4)";
            const SELECTOR: [u8; 4] = [120u8, 162u8, 34u8, 28u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::FixedBytes<
                        4,
                    > as alloy_sol_types::SolType>::tokenize(&self.expected),
                    <alloy::sol_types::sol_data::FixedBytes<
                        4,
                    > as alloy_sol_types::SolType>::tokenize(&self.actual),
                )
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `RiscZeroVerifierStopped()` and selector `0x0b1d38a3`.
```solidity
error RiscZeroVerifierStopped();
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct RiscZeroVerifierStopped;
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = ();
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = ();
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<RiscZeroVerifierStopped> for UnderlyingRustTuple<'_> {
            fn from(value: RiscZeroVerifierStopped) -> Self {
                ()
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for RiscZeroVerifierStopped {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for RiscZeroVerifierStopped {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "RiscZeroVerifierStopped()";
            const SELECTOR: [u8; 4] = [11u8, 29u8, 56u8, 163u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `Simulated(uint256)` and selector `0x6f149831`.
```solidity
error Simulated(uint256 gasUsed);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct Simulated {
        #[allow(missing_docs)]
        pub gasUsed: alloy::sol_types::private::primitives::aliases::U256,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::Uint<256>,);
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (
            alloy::sol_types::private::primitives::aliases::U256,
        );
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<Simulated> for UnderlyingRustTuple<'_> {
            fn from(value: Simulated) -> Self {
                (value.gasUsed,)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for Simulated {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self { gasUsed: tuple.0 }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for Simulated {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "Simulated(uint256)";
            const SELECTOR: [u8; 4] = [111u8, 20u8, 152u8, 49u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::SolType>::tokenize(&self.gasUsed),
                )
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `TagCountMismatch(uint256,uint256)` and selector `0xd3bee78d`.
```solidity
error TagCountMismatch(uint256 expected, uint256 actual);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct TagCountMismatch {
        #[allow(missing_docs)]
        pub expected: alloy::sol_types::private::primitives::aliases::U256,
        #[allow(missing_docs)]
        pub actual: alloy::sol_types::private::primitives::aliases::U256,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (
            alloy::sol_types::sol_data::Uint<256>,
            alloy::sol_types::sol_data::Uint<256>,
        );
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (
            alloy::sol_types::private::primitives::aliases::U256,
            alloy::sol_types::private::primitives::aliases::U256,
        );
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<TagCountMismatch> for UnderlyingRustTuple<'_> {
            fn from(value: TagCountMismatch) -> Self {
                (value.expected, value.actual)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for TagCountMismatch {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self {
                    expected: tuple.0,
                    actual: tuple.1,
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for TagCountMismatch {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "TagCountMismatch(uint256,uint256)";
            const SELECTOR: [u8; 4] = [211u8, 190u8, 231u8, 141u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::SolType>::tokenize(&self.expected),
                    <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::SolType>::tokenize(&self.actual),
                )
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `TagNotFound(bytes32)` and selector `0x89211474`.
```solidity
error TagNotFound(bytes32 tag);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct TagNotFound {
        #[allow(missing_docs)]
        pub tag: alloy::sol_types::private::FixedBytes<32>,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::FixedBytes<32>,);
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = (alloy::sol_types::private::FixedBytes<32>,);
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<TagNotFound> for UnderlyingRustTuple<'_> {
            fn from(value: TagNotFound) -> Self {
                (value.tag,)
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for TagNotFound {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self { tag: tuple.0 }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for TagNotFound {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "TagNotFound(bytes32)";
            const SELECTOR: [u8; 4] = [137u8, 33u8, 20u8, 116u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.tag),
                )
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Custom error with signature `ZeroNotAllowed()` and selector `0xcf4b4e2e`.
```solidity
error ZeroNotAllowed();
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct ZeroNotAllowed;
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[doc(hidden)]
        #[allow(dead_code)]
        type UnderlyingSolTuple<'a> = ();
        #[doc(hidden)]
        type UnderlyingRustTuple<'a> = ();
        #[cfg(test)]
        #[allow(dead_code, unreachable_patterns)]
        fn _type_assertion(
            _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
        ) {
            match _t {
                alloy_sol_types::private::AssertTypeEq::<
                    <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                >(_) => {}
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<ZeroNotAllowed> for UnderlyingRustTuple<'_> {
            fn from(value: ZeroNotAllowed) -> Self {
                ()
            }
        }
        #[automatically_derived]
        #[doc(hidden)]
        impl ::core::convert::From<UnderlyingRustTuple<'_>> for ZeroNotAllowed {
            fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                Self
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolError for ZeroNotAllowed {
            type Parameters<'a> = UnderlyingSolTuple<'a>;
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "ZeroNotAllowed()";
            const SELECTOR: [u8; 4] = [207u8, 75u8, 78u8, 46u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn abi_decode_raw_validate(data: &[u8]) -> alloy_sol_types::Result<Self> {
                <Self::Parameters<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Self::new)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Event with signature `ActionExecuted(bytes32,uint256)` and selector `0x1cc9a0755dd734c1ebfe98b68ece200037e363eb366d0dee04e420e2f23cc010`.
```solidity
event ActionExecuted(bytes32 actionTreeRoot, uint256 actionTagCount);
```*/
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    #[derive(Clone)]
    pub struct ActionExecuted {
        #[allow(missing_docs)]
        pub actionTreeRoot: alloy::sol_types::private::FixedBytes<32>,
        #[allow(missing_docs)]
        pub actionTagCount: alloy::sol_types::private::primitives::aliases::U256,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[automatically_derived]
        impl alloy_sol_types::SolEvent for ActionExecuted {
            type DataTuple<'a> = (
                alloy::sol_types::sol_data::FixedBytes<32>,
                alloy::sol_types::sol_data::Uint<256>,
            );
            type DataToken<'a> = <Self::DataTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type TopicList = (alloy_sol_types::sol_data::FixedBytes<32>,);
            const SIGNATURE: &'static str = "ActionExecuted(bytes32,uint256)";
            const SIGNATURE_HASH: alloy_sol_types::private::B256 = alloy_sol_types::private::B256::new([
                28u8, 201u8, 160u8, 117u8, 93u8, 215u8, 52u8, 193u8, 235u8, 254u8, 152u8,
                182u8, 142u8, 206u8, 32u8, 0u8, 55u8, 227u8, 99u8, 235u8, 54u8, 109u8,
                13u8, 238u8, 4u8, 228u8, 32u8, 226u8, 242u8, 60u8, 192u8, 16u8,
            ]);
            const ANONYMOUS: bool = false;
            #[allow(unused_variables)]
            #[inline]
            fn new(
                topics: <Self::TopicList as alloy_sol_types::SolType>::RustType,
                data: <Self::DataTuple<'_> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                Self {
                    actionTreeRoot: data.0,
                    actionTagCount: data.1,
                }
            }
            #[inline]
            fn check_signature(
                topics: &<Self::TopicList as alloy_sol_types::SolType>::RustType,
            ) -> alloy_sol_types::Result<()> {
                if topics.0 != Self::SIGNATURE_HASH {
                    return Err(
                        alloy_sol_types::Error::invalid_event_signature_hash(
                            Self::SIGNATURE,
                            topics.0,
                            Self::SIGNATURE_HASH,
                        ),
                    );
                }
                Ok(())
            }
            #[inline]
            fn tokenize_body(&self) -> Self::DataToken<'_> {
                (
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.actionTreeRoot),
                    <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::SolType>::tokenize(&self.actionTagCount),
                )
            }
            #[inline]
            fn topics(&self) -> <Self::TopicList as alloy_sol_types::SolType>::RustType {
                (Self::SIGNATURE_HASH.into(),)
            }
            #[inline]
            fn encode_topics_raw(
                &self,
                out: &mut [alloy_sol_types::abi::token::WordToken],
            ) -> alloy_sol_types::Result<()> {
                if out.len() < <Self::TopicList as alloy_sol_types::TopicList>::COUNT {
                    return Err(alloy_sol_types::Error::Overrun);
                }
                out[0usize] = alloy_sol_types::abi::token::WordToken(
                    Self::SIGNATURE_HASH,
                );
                Ok(())
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::private::IntoLogData for ActionExecuted {
            fn to_log_data(&self) -> alloy_sol_types::private::LogData {
                From::from(self)
            }
            fn into_log_data(self) -> alloy_sol_types::private::LogData {
                From::from(&self)
            }
        }
        #[automatically_derived]
        impl From<&ActionExecuted> for alloy_sol_types::private::LogData {
            #[inline]
            fn from(this: &ActionExecuted) -> alloy_sol_types::private::LogData {
                alloy_sol_types::SolEvent::encode_log_data(this)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Event with signature `ApplicationPayload(bytes32,uint256,bytes)` and selector `0xa494dac4b7184843583f972e06783e2c3bb47f4f0137b8df52a860df07219f8c`.
```solidity
event ApplicationPayload(bytes32 indexed tag, uint256 index, bytes blob);
```*/
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    #[derive(Clone)]
    pub struct ApplicationPayload {
        #[allow(missing_docs)]
        pub tag: alloy::sol_types::private::FixedBytes<32>,
        #[allow(missing_docs)]
        pub index: alloy::sol_types::private::primitives::aliases::U256,
        #[allow(missing_docs)]
        pub blob: alloy::sol_types::private::Bytes,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[automatically_derived]
        impl alloy_sol_types::SolEvent for ApplicationPayload {
            type DataTuple<'a> = (
                alloy::sol_types::sol_data::Uint<256>,
                alloy::sol_types::sol_data::Bytes,
            );
            type DataToken<'a> = <Self::DataTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type TopicList = (
                alloy_sol_types::sol_data::FixedBytes<32>,
                alloy::sol_types::sol_data::FixedBytes<32>,
            );
            const SIGNATURE: &'static str = "ApplicationPayload(bytes32,uint256,bytes)";
            const SIGNATURE_HASH: alloy_sol_types::private::B256 = alloy_sol_types::private::B256::new([
                164u8, 148u8, 218u8, 196u8, 183u8, 24u8, 72u8, 67u8, 88u8, 63u8, 151u8,
                46u8, 6u8, 120u8, 62u8, 44u8, 59u8, 180u8, 127u8, 79u8, 1u8, 55u8, 184u8,
                223u8, 82u8, 168u8, 96u8, 223u8, 7u8, 33u8, 159u8, 140u8,
            ]);
            const ANONYMOUS: bool = false;
            #[allow(unused_variables)]
            #[inline]
            fn new(
                topics: <Self::TopicList as alloy_sol_types::SolType>::RustType,
                data: <Self::DataTuple<'_> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                Self {
                    tag: topics.1,
                    index: data.0,
                    blob: data.1,
                }
            }
            #[inline]
            fn check_signature(
                topics: &<Self::TopicList as alloy_sol_types::SolType>::RustType,
            ) -> alloy_sol_types::Result<()> {
                if topics.0 != Self::SIGNATURE_HASH {
                    return Err(
                        alloy_sol_types::Error::invalid_event_signature_hash(
                            Self::SIGNATURE,
                            topics.0,
                            Self::SIGNATURE_HASH,
                        ),
                    );
                }
                Ok(())
            }
            #[inline]
            fn tokenize_body(&self) -> Self::DataToken<'_> {
                (
                    <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::SolType>::tokenize(&self.index),
                    <alloy::sol_types::sol_data::Bytes as alloy_sol_types::SolType>::tokenize(
                        &self.blob,
                    ),
                )
            }
            #[inline]
            fn topics(&self) -> <Self::TopicList as alloy_sol_types::SolType>::RustType {
                (Self::SIGNATURE_HASH.into(), self.tag.clone())
            }
            #[inline]
            fn encode_topics_raw(
                &self,
                out: &mut [alloy_sol_types::abi::token::WordToken],
            ) -> alloy_sol_types::Result<()> {
                if out.len() < <Self::TopicList as alloy_sol_types::TopicList>::COUNT {
                    return Err(alloy_sol_types::Error::Overrun);
                }
                out[0usize] = alloy_sol_types::abi::token::WordToken(
                    Self::SIGNATURE_HASH,
                );
                out[1usize] = <alloy::sol_types::sol_data::FixedBytes<
                    32,
                > as alloy_sol_types::EventTopic>::encode_topic(&self.tag);
                Ok(())
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::private::IntoLogData for ApplicationPayload {
            fn to_log_data(&self) -> alloy_sol_types::private::LogData {
                From::from(self)
            }
            fn into_log_data(self) -> alloy_sol_types::private::LogData {
                From::from(&self)
            }
        }
        #[automatically_derived]
        impl From<&ApplicationPayload> for alloy_sol_types::private::LogData {
            #[inline]
            fn from(this: &ApplicationPayload) -> alloy_sol_types::private::LogData {
                alloy_sol_types::SolEvent::encode_log_data(this)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Event with signature `CommitmentTreeRootAdded(bytes32)` and selector `0x0a2dc548ed950accb40d5d78541f3954c5e182a8ecf19e581a4f2263f61f59d2`.
```solidity
event CommitmentTreeRootAdded(bytes32 root);
```*/
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    #[derive(Clone)]
    pub struct CommitmentTreeRootAdded {
        #[allow(missing_docs)]
        pub root: alloy::sol_types::private::FixedBytes<32>,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[automatically_derived]
        impl alloy_sol_types::SolEvent for CommitmentTreeRootAdded {
            type DataTuple<'a> = (alloy::sol_types::sol_data::FixedBytes<32>,);
            type DataToken<'a> = <Self::DataTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type TopicList = (alloy_sol_types::sol_data::FixedBytes<32>,);
            const SIGNATURE: &'static str = "CommitmentTreeRootAdded(bytes32)";
            const SIGNATURE_HASH: alloy_sol_types::private::B256 = alloy_sol_types::private::B256::new([
                10u8, 45u8, 197u8, 72u8, 237u8, 149u8, 10u8, 204u8, 180u8, 13u8, 93u8,
                120u8, 84u8, 31u8, 57u8, 84u8, 197u8, 225u8, 130u8, 168u8, 236u8, 241u8,
                158u8, 88u8, 26u8, 79u8, 34u8, 99u8, 246u8, 31u8, 89u8, 210u8,
            ]);
            const ANONYMOUS: bool = false;
            #[allow(unused_variables)]
            #[inline]
            fn new(
                topics: <Self::TopicList as alloy_sol_types::SolType>::RustType,
                data: <Self::DataTuple<'_> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                Self { root: data.0 }
            }
            #[inline]
            fn check_signature(
                topics: &<Self::TopicList as alloy_sol_types::SolType>::RustType,
            ) -> alloy_sol_types::Result<()> {
                if topics.0 != Self::SIGNATURE_HASH {
                    return Err(
                        alloy_sol_types::Error::invalid_event_signature_hash(
                            Self::SIGNATURE,
                            topics.0,
                            Self::SIGNATURE_HASH,
                        ),
                    );
                }
                Ok(())
            }
            #[inline]
            fn tokenize_body(&self) -> Self::DataToken<'_> {
                (
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.root),
                )
            }
            #[inline]
            fn topics(&self) -> <Self::TopicList as alloy_sol_types::SolType>::RustType {
                (Self::SIGNATURE_HASH.into(),)
            }
            #[inline]
            fn encode_topics_raw(
                &self,
                out: &mut [alloy_sol_types::abi::token::WordToken],
            ) -> alloy_sol_types::Result<()> {
                if out.len() < <Self::TopicList as alloy_sol_types::TopicList>::COUNT {
                    return Err(alloy_sol_types::Error::Overrun);
                }
                out[0usize] = alloy_sol_types::abi::token::WordToken(
                    Self::SIGNATURE_HASH,
                );
                Ok(())
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::private::IntoLogData for CommitmentTreeRootAdded {
            fn to_log_data(&self) -> alloy_sol_types::private::LogData {
                From::from(self)
            }
            fn into_log_data(self) -> alloy_sol_types::private::LogData {
                From::from(&self)
            }
        }
        #[automatically_derived]
        impl From<&CommitmentTreeRootAdded> for alloy_sol_types::private::LogData {
            #[inline]
            fn from(
                this: &CommitmentTreeRootAdded,
            ) -> alloy_sol_types::private::LogData {
                alloy_sol_types::SolEvent::encode_log_data(this)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Event with signature `DiscoveryPayload(bytes32,uint256,bytes)` and selector `0x48243873b4752ddcb45e0d7b11c4c266583e5e099a0b798fdd9c1af7d49324f3`.
```solidity
event DiscoveryPayload(bytes32 indexed tag, uint256 index, bytes blob);
```*/
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    #[derive(Clone)]
    pub struct DiscoveryPayload {
        #[allow(missing_docs)]
        pub tag: alloy::sol_types::private::FixedBytes<32>,
        #[allow(missing_docs)]
        pub index: alloy::sol_types::private::primitives::aliases::U256,
        #[allow(missing_docs)]
        pub blob: alloy::sol_types::private::Bytes,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[automatically_derived]
        impl alloy_sol_types::SolEvent for DiscoveryPayload {
            type DataTuple<'a> = (
                alloy::sol_types::sol_data::Uint<256>,
                alloy::sol_types::sol_data::Bytes,
            );
            type DataToken<'a> = <Self::DataTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type TopicList = (
                alloy_sol_types::sol_data::FixedBytes<32>,
                alloy::sol_types::sol_data::FixedBytes<32>,
            );
            const SIGNATURE: &'static str = "DiscoveryPayload(bytes32,uint256,bytes)";
            const SIGNATURE_HASH: alloy_sol_types::private::B256 = alloy_sol_types::private::B256::new([
                72u8, 36u8, 56u8, 115u8, 180u8, 117u8, 45u8, 220u8, 180u8, 94u8, 13u8,
                123u8, 17u8, 196u8, 194u8, 102u8, 88u8, 62u8, 94u8, 9u8, 154u8, 11u8,
                121u8, 143u8, 221u8, 156u8, 26u8, 247u8, 212u8, 147u8, 36u8, 243u8,
            ]);
            const ANONYMOUS: bool = false;
            #[allow(unused_variables)]
            #[inline]
            fn new(
                topics: <Self::TopicList as alloy_sol_types::SolType>::RustType,
                data: <Self::DataTuple<'_> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                Self {
                    tag: topics.1,
                    index: data.0,
                    blob: data.1,
                }
            }
            #[inline]
            fn check_signature(
                topics: &<Self::TopicList as alloy_sol_types::SolType>::RustType,
            ) -> alloy_sol_types::Result<()> {
                if topics.0 != Self::SIGNATURE_HASH {
                    return Err(
                        alloy_sol_types::Error::invalid_event_signature_hash(
                            Self::SIGNATURE,
                            topics.0,
                            Self::SIGNATURE_HASH,
                        ),
                    );
                }
                Ok(())
            }
            #[inline]
            fn tokenize_body(&self) -> Self::DataToken<'_> {
                (
                    <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::SolType>::tokenize(&self.index),
                    <alloy::sol_types::sol_data::Bytes as alloy_sol_types::SolType>::tokenize(
                        &self.blob,
                    ),
                )
            }
            #[inline]
            fn topics(&self) -> <Self::TopicList as alloy_sol_types::SolType>::RustType {
                (Self::SIGNATURE_HASH.into(), self.tag.clone())
            }
            #[inline]
            fn encode_topics_raw(
                &self,
                out: &mut [alloy_sol_types::abi::token::WordToken],
            ) -> alloy_sol_types::Result<()> {
                if out.len() < <Self::TopicList as alloy_sol_types::TopicList>::COUNT {
                    return Err(alloy_sol_types::Error::Overrun);
                }
                out[0usize] = alloy_sol_types::abi::token::WordToken(
                    Self::SIGNATURE_HASH,
                );
                out[1usize] = <alloy::sol_types::sol_data::FixedBytes<
                    32,
                > as alloy_sol_types::EventTopic>::encode_topic(&self.tag);
                Ok(())
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::private::IntoLogData for DiscoveryPayload {
            fn to_log_data(&self) -> alloy_sol_types::private::LogData {
                From::from(self)
            }
            fn into_log_data(self) -> alloy_sol_types::private::LogData {
                From::from(&self)
            }
        }
        #[automatically_derived]
        impl From<&DiscoveryPayload> for alloy_sol_types::private::LogData {
            #[inline]
            fn from(this: &DiscoveryPayload) -> alloy_sol_types::private::LogData {
                alloy_sol_types::SolEvent::encode_log_data(this)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Event with signature `ExternalPayload(bytes32,uint256,bytes)` and selector `0x9c61b290f631097f56273cf4daf40df1ff9ccc33f101d464837da1f5ae18bd59`.
```solidity
event ExternalPayload(bytes32 indexed tag, uint256 index, bytes blob);
```*/
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    #[derive(Clone)]
    pub struct ExternalPayload {
        #[allow(missing_docs)]
        pub tag: alloy::sol_types::private::FixedBytes<32>,
        #[allow(missing_docs)]
        pub index: alloy::sol_types::private::primitives::aliases::U256,
        #[allow(missing_docs)]
        pub blob: alloy::sol_types::private::Bytes,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[automatically_derived]
        impl alloy_sol_types::SolEvent for ExternalPayload {
            type DataTuple<'a> = (
                alloy::sol_types::sol_data::Uint<256>,
                alloy::sol_types::sol_data::Bytes,
            );
            type DataToken<'a> = <Self::DataTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type TopicList = (
                alloy_sol_types::sol_data::FixedBytes<32>,
                alloy::sol_types::sol_data::FixedBytes<32>,
            );
            const SIGNATURE: &'static str = "ExternalPayload(bytes32,uint256,bytes)";
            const SIGNATURE_HASH: alloy_sol_types::private::B256 = alloy_sol_types::private::B256::new([
                156u8, 97u8, 178u8, 144u8, 246u8, 49u8, 9u8, 127u8, 86u8, 39u8, 60u8,
                244u8, 218u8, 244u8, 13u8, 241u8, 255u8, 156u8, 204u8, 51u8, 241u8, 1u8,
                212u8, 100u8, 131u8, 125u8, 161u8, 245u8, 174u8, 24u8, 189u8, 89u8,
            ]);
            const ANONYMOUS: bool = false;
            #[allow(unused_variables)]
            #[inline]
            fn new(
                topics: <Self::TopicList as alloy_sol_types::SolType>::RustType,
                data: <Self::DataTuple<'_> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                Self {
                    tag: topics.1,
                    index: data.0,
                    blob: data.1,
                }
            }
            #[inline]
            fn check_signature(
                topics: &<Self::TopicList as alloy_sol_types::SolType>::RustType,
            ) -> alloy_sol_types::Result<()> {
                if topics.0 != Self::SIGNATURE_HASH {
                    return Err(
                        alloy_sol_types::Error::invalid_event_signature_hash(
                            Self::SIGNATURE,
                            topics.0,
                            Self::SIGNATURE_HASH,
                        ),
                    );
                }
                Ok(())
            }
            #[inline]
            fn tokenize_body(&self) -> Self::DataToken<'_> {
                (
                    <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::SolType>::tokenize(&self.index),
                    <alloy::sol_types::sol_data::Bytes as alloy_sol_types::SolType>::tokenize(
                        &self.blob,
                    ),
                )
            }
            #[inline]
            fn topics(&self) -> <Self::TopicList as alloy_sol_types::SolType>::RustType {
                (Self::SIGNATURE_HASH.into(), self.tag.clone())
            }
            #[inline]
            fn encode_topics_raw(
                &self,
                out: &mut [alloy_sol_types::abi::token::WordToken],
            ) -> alloy_sol_types::Result<()> {
                if out.len() < <Self::TopicList as alloy_sol_types::TopicList>::COUNT {
                    return Err(alloy_sol_types::Error::Overrun);
                }
                out[0usize] = alloy_sol_types::abi::token::WordToken(
                    Self::SIGNATURE_HASH,
                );
                out[1usize] = <alloy::sol_types::sol_data::FixedBytes<
                    32,
                > as alloy_sol_types::EventTopic>::encode_topic(&self.tag);
                Ok(())
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::private::IntoLogData for ExternalPayload {
            fn to_log_data(&self) -> alloy_sol_types::private::LogData {
                From::from(self)
            }
            fn into_log_data(self) -> alloy_sol_types::private::LogData {
                From::from(&self)
            }
        }
        #[automatically_derived]
        impl From<&ExternalPayload> for alloy_sol_types::private::LogData {
            #[inline]
            fn from(this: &ExternalPayload) -> alloy_sol_types::private::LogData {
                alloy_sol_types::SolEvent::encode_log_data(this)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Event with signature `ForwarderCallExecuted(address,bytes,bytes)` and selector `0xcddb327adb31fe5437df2a8c68301bb13a6baae432a804838caaf682506aadf1`.
```solidity
event ForwarderCallExecuted(address indexed untrustedForwarder, bytes input, bytes output);
```*/
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    #[derive(Clone)]
    pub struct ForwarderCallExecuted {
        #[allow(missing_docs)]
        pub untrustedForwarder: alloy::sol_types::private::Address,
        #[allow(missing_docs)]
        pub input: alloy::sol_types::private::Bytes,
        #[allow(missing_docs)]
        pub output: alloy::sol_types::private::Bytes,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[automatically_derived]
        impl alloy_sol_types::SolEvent for ForwarderCallExecuted {
            type DataTuple<'a> = (
                alloy::sol_types::sol_data::Bytes,
                alloy::sol_types::sol_data::Bytes,
            );
            type DataToken<'a> = <Self::DataTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type TopicList = (
                alloy_sol_types::sol_data::FixedBytes<32>,
                alloy::sol_types::sol_data::Address,
            );
            const SIGNATURE: &'static str = "ForwarderCallExecuted(address,bytes,bytes)";
            const SIGNATURE_HASH: alloy_sol_types::private::B256 = alloy_sol_types::private::B256::new([
                205u8, 219u8, 50u8, 122u8, 219u8, 49u8, 254u8, 84u8, 55u8, 223u8, 42u8,
                140u8, 104u8, 48u8, 27u8, 177u8, 58u8, 107u8, 170u8, 228u8, 50u8, 168u8,
                4u8, 131u8, 140u8, 170u8, 246u8, 130u8, 80u8, 106u8, 173u8, 241u8,
            ]);
            const ANONYMOUS: bool = false;
            #[allow(unused_variables)]
            #[inline]
            fn new(
                topics: <Self::TopicList as alloy_sol_types::SolType>::RustType,
                data: <Self::DataTuple<'_> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                Self {
                    untrustedForwarder: topics.1,
                    input: data.0,
                    output: data.1,
                }
            }
            #[inline]
            fn check_signature(
                topics: &<Self::TopicList as alloy_sol_types::SolType>::RustType,
            ) -> alloy_sol_types::Result<()> {
                if topics.0 != Self::SIGNATURE_HASH {
                    return Err(
                        alloy_sol_types::Error::invalid_event_signature_hash(
                            Self::SIGNATURE,
                            topics.0,
                            Self::SIGNATURE_HASH,
                        ),
                    );
                }
                Ok(())
            }
            #[inline]
            fn tokenize_body(&self) -> Self::DataToken<'_> {
                (
                    <alloy::sol_types::sol_data::Bytes as alloy_sol_types::SolType>::tokenize(
                        &self.input,
                    ),
                    <alloy::sol_types::sol_data::Bytes as alloy_sol_types::SolType>::tokenize(
                        &self.output,
                    ),
                )
            }
            #[inline]
            fn topics(&self) -> <Self::TopicList as alloy_sol_types::SolType>::RustType {
                (Self::SIGNATURE_HASH.into(), self.untrustedForwarder.clone())
            }
            #[inline]
            fn encode_topics_raw(
                &self,
                out: &mut [alloy_sol_types::abi::token::WordToken],
            ) -> alloy_sol_types::Result<()> {
                if out.len() < <Self::TopicList as alloy_sol_types::TopicList>::COUNT {
                    return Err(alloy_sol_types::Error::Overrun);
                }
                out[0usize] = alloy_sol_types::abi::token::WordToken(
                    Self::SIGNATURE_HASH,
                );
                out[1usize] = <alloy::sol_types::sol_data::Address as alloy_sol_types::EventTopic>::encode_topic(
                    &self.untrustedForwarder,
                );
                Ok(())
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::private::IntoLogData for ForwarderCallExecuted {
            fn to_log_data(&self) -> alloy_sol_types::private::LogData {
                From::from(self)
            }
            fn into_log_data(self) -> alloy_sol_types::private::LogData {
                From::from(&self)
            }
        }
        #[automatically_derived]
        impl From<&ForwarderCallExecuted> for alloy_sol_types::private::LogData {
            #[inline]
            fn from(this: &ForwarderCallExecuted) -> alloy_sol_types::private::LogData {
                alloy_sol_types::SolEvent::encode_log_data(this)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Event with signature `OwnershipTransferred(address,address)` and selector `0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0`.
```solidity
event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
```*/
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    #[derive(Clone)]
    pub struct OwnershipTransferred {
        #[allow(missing_docs)]
        pub previousOwner: alloy::sol_types::private::Address,
        #[allow(missing_docs)]
        pub newOwner: alloy::sol_types::private::Address,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[automatically_derived]
        impl alloy_sol_types::SolEvent for OwnershipTransferred {
            type DataTuple<'a> = ();
            type DataToken<'a> = <Self::DataTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type TopicList = (
                alloy_sol_types::sol_data::FixedBytes<32>,
                alloy::sol_types::sol_data::Address,
                alloy::sol_types::sol_data::Address,
            );
            const SIGNATURE: &'static str = "OwnershipTransferred(address,address)";
            const SIGNATURE_HASH: alloy_sol_types::private::B256 = alloy_sol_types::private::B256::new([
                139u8, 224u8, 7u8, 156u8, 83u8, 22u8, 89u8, 20u8, 19u8, 68u8, 205u8,
                31u8, 208u8, 164u8, 242u8, 132u8, 25u8, 73u8, 127u8, 151u8, 34u8, 163u8,
                218u8, 175u8, 227u8, 180u8, 24u8, 111u8, 107u8, 100u8, 87u8, 224u8,
            ]);
            const ANONYMOUS: bool = false;
            #[allow(unused_variables)]
            #[inline]
            fn new(
                topics: <Self::TopicList as alloy_sol_types::SolType>::RustType,
                data: <Self::DataTuple<'_> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                Self {
                    previousOwner: topics.1,
                    newOwner: topics.2,
                }
            }
            #[inline]
            fn check_signature(
                topics: &<Self::TopicList as alloy_sol_types::SolType>::RustType,
            ) -> alloy_sol_types::Result<()> {
                if topics.0 != Self::SIGNATURE_HASH {
                    return Err(
                        alloy_sol_types::Error::invalid_event_signature_hash(
                            Self::SIGNATURE,
                            topics.0,
                            Self::SIGNATURE_HASH,
                        ),
                    );
                }
                Ok(())
            }
            #[inline]
            fn tokenize_body(&self) -> Self::DataToken<'_> {
                ()
            }
            #[inline]
            fn topics(&self) -> <Self::TopicList as alloy_sol_types::SolType>::RustType {
                (
                    Self::SIGNATURE_HASH.into(),
                    self.previousOwner.clone(),
                    self.newOwner.clone(),
                )
            }
            #[inline]
            fn encode_topics_raw(
                &self,
                out: &mut [alloy_sol_types::abi::token::WordToken],
            ) -> alloy_sol_types::Result<()> {
                if out.len() < <Self::TopicList as alloy_sol_types::TopicList>::COUNT {
                    return Err(alloy_sol_types::Error::Overrun);
                }
                out[0usize] = alloy_sol_types::abi::token::WordToken(
                    Self::SIGNATURE_HASH,
                );
                out[1usize] = <alloy::sol_types::sol_data::Address as alloy_sol_types::EventTopic>::encode_topic(
                    &self.previousOwner,
                );
                out[2usize] = <alloy::sol_types::sol_data::Address as alloy_sol_types::EventTopic>::encode_topic(
                    &self.newOwner,
                );
                Ok(())
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::private::IntoLogData for OwnershipTransferred {
            fn to_log_data(&self) -> alloy_sol_types::private::LogData {
                From::from(self)
            }
            fn into_log_data(self) -> alloy_sol_types::private::LogData {
                From::from(&self)
            }
        }
        #[automatically_derived]
        impl From<&OwnershipTransferred> for alloy_sol_types::private::LogData {
            #[inline]
            fn from(this: &OwnershipTransferred) -> alloy_sol_types::private::LogData {
                alloy_sol_types::SolEvent::encode_log_data(this)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Event with signature `Paused(address)` and selector `0x62e78cea01bee320cd4e420270b5ea74000d11b0c9f74754ebdbfc544b05a258`.
```solidity
event Paused(address account);
```*/
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    #[derive(Clone)]
    pub struct Paused {
        #[allow(missing_docs)]
        pub account: alloy::sol_types::private::Address,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[automatically_derived]
        impl alloy_sol_types::SolEvent for Paused {
            type DataTuple<'a> = (alloy::sol_types::sol_data::Address,);
            type DataToken<'a> = <Self::DataTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type TopicList = (alloy_sol_types::sol_data::FixedBytes<32>,);
            const SIGNATURE: &'static str = "Paused(address)";
            const SIGNATURE_HASH: alloy_sol_types::private::B256 = alloy_sol_types::private::B256::new([
                98u8, 231u8, 140u8, 234u8, 1u8, 190u8, 227u8, 32u8, 205u8, 78u8, 66u8,
                2u8, 112u8, 181u8, 234u8, 116u8, 0u8, 13u8, 17u8, 176u8, 201u8, 247u8,
                71u8, 84u8, 235u8, 219u8, 252u8, 84u8, 75u8, 5u8, 162u8, 88u8,
            ]);
            const ANONYMOUS: bool = false;
            #[allow(unused_variables)]
            #[inline]
            fn new(
                topics: <Self::TopicList as alloy_sol_types::SolType>::RustType,
                data: <Self::DataTuple<'_> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                Self { account: data.0 }
            }
            #[inline]
            fn check_signature(
                topics: &<Self::TopicList as alloy_sol_types::SolType>::RustType,
            ) -> alloy_sol_types::Result<()> {
                if topics.0 != Self::SIGNATURE_HASH {
                    return Err(
                        alloy_sol_types::Error::invalid_event_signature_hash(
                            Self::SIGNATURE,
                            topics.0,
                            Self::SIGNATURE_HASH,
                        ),
                    );
                }
                Ok(())
            }
            #[inline]
            fn tokenize_body(&self) -> Self::DataToken<'_> {
                (
                    <alloy::sol_types::sol_data::Address as alloy_sol_types::SolType>::tokenize(
                        &self.account,
                    ),
                )
            }
            #[inline]
            fn topics(&self) -> <Self::TopicList as alloy_sol_types::SolType>::RustType {
                (Self::SIGNATURE_HASH.into(),)
            }
            #[inline]
            fn encode_topics_raw(
                &self,
                out: &mut [alloy_sol_types::abi::token::WordToken],
            ) -> alloy_sol_types::Result<()> {
                if out.len() < <Self::TopicList as alloy_sol_types::TopicList>::COUNT {
                    return Err(alloy_sol_types::Error::Overrun);
                }
                out[0usize] = alloy_sol_types::abi::token::WordToken(
                    Self::SIGNATURE_HASH,
                );
                Ok(())
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::private::IntoLogData for Paused {
            fn to_log_data(&self) -> alloy_sol_types::private::LogData {
                From::from(self)
            }
            fn into_log_data(self) -> alloy_sol_types::private::LogData {
                From::from(&self)
            }
        }
        #[automatically_derived]
        impl From<&Paused> for alloy_sol_types::private::LogData {
            #[inline]
            fn from(this: &Paused) -> alloy_sol_types::private::LogData {
                alloy_sol_types::SolEvent::encode_log_data(this)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Event with signature `ResourcePayload(bytes32,uint256,bytes)` and selector `0x3a134d01c07803003c63301717ddc4612e6c47ae408eeea3222cded532d02ae6`.
```solidity
event ResourcePayload(bytes32 indexed tag, uint256 index, bytes blob);
```*/
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    #[derive(Clone)]
    pub struct ResourcePayload {
        #[allow(missing_docs)]
        pub tag: alloy::sol_types::private::FixedBytes<32>,
        #[allow(missing_docs)]
        pub index: alloy::sol_types::private::primitives::aliases::U256,
        #[allow(missing_docs)]
        pub blob: alloy::sol_types::private::Bytes,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[automatically_derived]
        impl alloy_sol_types::SolEvent for ResourcePayload {
            type DataTuple<'a> = (
                alloy::sol_types::sol_data::Uint<256>,
                alloy::sol_types::sol_data::Bytes,
            );
            type DataToken<'a> = <Self::DataTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type TopicList = (
                alloy_sol_types::sol_data::FixedBytes<32>,
                alloy::sol_types::sol_data::FixedBytes<32>,
            );
            const SIGNATURE: &'static str = "ResourcePayload(bytes32,uint256,bytes)";
            const SIGNATURE_HASH: alloy_sol_types::private::B256 = alloy_sol_types::private::B256::new([
                58u8, 19u8, 77u8, 1u8, 192u8, 120u8, 3u8, 0u8, 60u8, 99u8, 48u8, 23u8,
                23u8, 221u8, 196u8, 97u8, 46u8, 108u8, 71u8, 174u8, 64u8, 142u8, 238u8,
                163u8, 34u8, 44u8, 222u8, 213u8, 50u8, 208u8, 42u8, 230u8,
            ]);
            const ANONYMOUS: bool = false;
            #[allow(unused_variables)]
            #[inline]
            fn new(
                topics: <Self::TopicList as alloy_sol_types::SolType>::RustType,
                data: <Self::DataTuple<'_> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                Self {
                    tag: topics.1,
                    index: data.0,
                    blob: data.1,
                }
            }
            #[inline]
            fn check_signature(
                topics: &<Self::TopicList as alloy_sol_types::SolType>::RustType,
            ) -> alloy_sol_types::Result<()> {
                if topics.0 != Self::SIGNATURE_HASH {
                    return Err(
                        alloy_sol_types::Error::invalid_event_signature_hash(
                            Self::SIGNATURE,
                            topics.0,
                            Self::SIGNATURE_HASH,
                        ),
                    );
                }
                Ok(())
            }
            #[inline]
            fn tokenize_body(&self) -> Self::DataToken<'_> {
                (
                    <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::SolType>::tokenize(&self.index),
                    <alloy::sol_types::sol_data::Bytes as alloy_sol_types::SolType>::tokenize(
                        &self.blob,
                    ),
                )
            }
            #[inline]
            fn topics(&self) -> <Self::TopicList as alloy_sol_types::SolType>::RustType {
                (Self::SIGNATURE_HASH.into(), self.tag.clone())
            }
            #[inline]
            fn encode_topics_raw(
                &self,
                out: &mut [alloy_sol_types::abi::token::WordToken],
            ) -> alloy_sol_types::Result<()> {
                if out.len() < <Self::TopicList as alloy_sol_types::TopicList>::COUNT {
                    return Err(alloy_sol_types::Error::Overrun);
                }
                out[0usize] = alloy_sol_types::abi::token::WordToken(
                    Self::SIGNATURE_HASH,
                );
                out[1usize] = <alloy::sol_types::sol_data::FixedBytes<
                    32,
                > as alloy_sol_types::EventTopic>::encode_topic(&self.tag);
                Ok(())
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::private::IntoLogData for ResourcePayload {
            fn to_log_data(&self) -> alloy_sol_types::private::LogData {
                From::from(self)
            }
            fn into_log_data(self) -> alloy_sol_types::private::LogData {
                From::from(&self)
            }
        }
        #[automatically_derived]
        impl From<&ResourcePayload> for alloy_sol_types::private::LogData {
            #[inline]
            fn from(this: &ResourcePayload) -> alloy_sol_types::private::LogData {
                alloy_sol_types::SolEvent::encode_log_data(this)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Event with signature `TransactionExecuted(bytes32[],bytes32[])` and selector `0x10dd528db2c49add6545679b976df90d24c035d6a75b17f41b700e8c18ca5364`.
```solidity
event TransactionExecuted(bytes32[] tags, bytes32[] logicRefs);
```*/
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    #[derive(Clone)]
    pub struct TransactionExecuted {
        #[allow(missing_docs)]
        pub tags: alloy::sol_types::private::Vec<
            alloy::sol_types::private::FixedBytes<32>,
        >,
        #[allow(missing_docs)]
        pub logicRefs: alloy::sol_types::private::Vec<
            alloy::sol_types::private::FixedBytes<32>,
        >,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[automatically_derived]
        impl alloy_sol_types::SolEvent for TransactionExecuted {
            type DataTuple<'a> = (
                alloy::sol_types::sol_data::Array<
                    alloy::sol_types::sol_data::FixedBytes<32>,
                >,
                alloy::sol_types::sol_data::Array<
                    alloy::sol_types::sol_data::FixedBytes<32>,
                >,
            );
            type DataToken<'a> = <Self::DataTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type TopicList = (alloy_sol_types::sol_data::FixedBytes<32>,);
            const SIGNATURE: &'static str = "TransactionExecuted(bytes32[],bytes32[])";
            const SIGNATURE_HASH: alloy_sol_types::private::B256 = alloy_sol_types::private::B256::new([
                16u8, 221u8, 82u8, 141u8, 178u8, 196u8, 154u8, 221u8, 101u8, 69u8, 103u8,
                155u8, 151u8, 109u8, 249u8, 13u8, 36u8, 192u8, 53u8, 214u8, 167u8, 91u8,
                23u8, 244u8, 27u8, 112u8, 14u8, 140u8, 24u8, 202u8, 83u8, 100u8,
            ]);
            const ANONYMOUS: bool = false;
            #[allow(unused_variables)]
            #[inline]
            fn new(
                topics: <Self::TopicList as alloy_sol_types::SolType>::RustType,
                data: <Self::DataTuple<'_> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                Self {
                    tags: data.0,
                    logicRefs: data.1,
                }
            }
            #[inline]
            fn check_signature(
                topics: &<Self::TopicList as alloy_sol_types::SolType>::RustType,
            ) -> alloy_sol_types::Result<()> {
                if topics.0 != Self::SIGNATURE_HASH {
                    return Err(
                        alloy_sol_types::Error::invalid_event_signature_hash(
                            Self::SIGNATURE,
                            topics.0,
                            Self::SIGNATURE_HASH,
                        ),
                    );
                }
                Ok(())
            }
            #[inline]
            fn tokenize_body(&self) -> Self::DataToken<'_> {
                (
                    <alloy::sol_types::sol_data::Array<
                        alloy::sol_types::sol_data::FixedBytes<32>,
                    > as alloy_sol_types::SolType>::tokenize(&self.tags),
                    <alloy::sol_types::sol_data::Array<
                        alloy::sol_types::sol_data::FixedBytes<32>,
                    > as alloy_sol_types::SolType>::tokenize(&self.logicRefs),
                )
            }
            #[inline]
            fn topics(&self) -> <Self::TopicList as alloy_sol_types::SolType>::RustType {
                (Self::SIGNATURE_HASH.into(),)
            }
            #[inline]
            fn encode_topics_raw(
                &self,
                out: &mut [alloy_sol_types::abi::token::WordToken],
            ) -> alloy_sol_types::Result<()> {
                if out.len() < <Self::TopicList as alloy_sol_types::TopicList>::COUNT {
                    return Err(alloy_sol_types::Error::Overrun);
                }
                out[0usize] = alloy_sol_types::abi::token::WordToken(
                    Self::SIGNATURE_HASH,
                );
                Ok(())
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::private::IntoLogData for TransactionExecuted {
            fn to_log_data(&self) -> alloy_sol_types::private::LogData {
                From::from(self)
            }
            fn into_log_data(self) -> alloy_sol_types::private::LogData {
                From::from(&self)
            }
        }
        #[automatically_derived]
        impl From<&TransactionExecuted> for alloy_sol_types::private::LogData {
            #[inline]
            fn from(this: &TransactionExecuted) -> alloy_sol_types::private::LogData {
                alloy_sol_types::SolEvent::encode_log_data(this)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Event with signature `Unpaused(address)` and selector `0x5db9ee0a495bf2e6ff9c91a7834c1ba4fdd244a5e8aa4e537bd38aeae4b073aa`.
```solidity
event Unpaused(address account);
```*/
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    #[derive(Clone)]
    pub struct Unpaused {
        #[allow(missing_docs)]
        pub account: alloy::sol_types::private::Address,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        #[automatically_derived]
        impl alloy_sol_types::SolEvent for Unpaused {
            type DataTuple<'a> = (alloy::sol_types::sol_data::Address,);
            type DataToken<'a> = <Self::DataTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type TopicList = (alloy_sol_types::sol_data::FixedBytes<32>,);
            const SIGNATURE: &'static str = "Unpaused(address)";
            const SIGNATURE_HASH: alloy_sol_types::private::B256 = alloy_sol_types::private::B256::new([
                93u8, 185u8, 238u8, 10u8, 73u8, 91u8, 242u8, 230u8, 255u8, 156u8, 145u8,
                167u8, 131u8, 76u8, 27u8, 164u8, 253u8, 210u8, 68u8, 165u8, 232u8, 170u8,
                78u8, 83u8, 123u8, 211u8, 138u8, 234u8, 228u8, 176u8, 115u8, 170u8,
            ]);
            const ANONYMOUS: bool = false;
            #[allow(unused_variables)]
            #[inline]
            fn new(
                topics: <Self::TopicList as alloy_sol_types::SolType>::RustType,
                data: <Self::DataTuple<'_> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                Self { account: data.0 }
            }
            #[inline]
            fn check_signature(
                topics: &<Self::TopicList as alloy_sol_types::SolType>::RustType,
            ) -> alloy_sol_types::Result<()> {
                if topics.0 != Self::SIGNATURE_HASH {
                    return Err(
                        alloy_sol_types::Error::invalid_event_signature_hash(
                            Self::SIGNATURE,
                            topics.0,
                            Self::SIGNATURE_HASH,
                        ),
                    );
                }
                Ok(())
            }
            #[inline]
            fn tokenize_body(&self) -> Self::DataToken<'_> {
                (
                    <alloy::sol_types::sol_data::Address as alloy_sol_types::SolType>::tokenize(
                        &self.account,
                    ),
                )
            }
            #[inline]
            fn topics(&self) -> <Self::TopicList as alloy_sol_types::SolType>::RustType {
                (Self::SIGNATURE_HASH.into(),)
            }
            #[inline]
            fn encode_topics_raw(
                &self,
                out: &mut [alloy_sol_types::abi::token::WordToken],
            ) -> alloy_sol_types::Result<()> {
                if out.len() < <Self::TopicList as alloy_sol_types::TopicList>::COUNT {
                    return Err(alloy_sol_types::Error::Overrun);
                }
                out[0usize] = alloy_sol_types::abi::token::WordToken(
                    Self::SIGNATURE_HASH,
                );
                Ok(())
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::private::IntoLogData for Unpaused {
            fn to_log_data(&self) -> alloy_sol_types::private::LogData {
                From::from(self)
            }
            fn into_log_data(self) -> alloy_sol_types::private::LogData {
                From::from(&self)
            }
        }
        #[automatically_derived]
        impl From<&Unpaused> for alloy_sol_types::private::LogData {
            #[inline]
            fn from(this: &Unpaused) -> alloy_sol_types::private::LogData {
                alloy_sol_types::SolEvent::encode_log_data(this)
            }
        }
    };
    /**Constructor`.
```solidity
constructor(address riscZeroVerifierRouter, bytes4 riscZeroVerifierSelector, address emergencyStopCaller);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct constructorCall {
        #[allow(missing_docs)]
        pub riscZeroVerifierRouter: alloy::sol_types::private::Address,
        #[allow(missing_docs)]
        pub riscZeroVerifierSelector: alloy::sol_types::private::FixedBytes<4>,
        #[allow(missing_docs)]
        pub emergencyStopCaller: alloy::sol_types::private::Address,
    }
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (
                alloy::sol_types::sol_data::Address,
                alloy::sol_types::sol_data::FixedBytes<4>,
                alloy::sol_types::sol_data::Address,
            );
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (
                alloy::sol_types::private::Address,
                alloy::sol_types::private::FixedBytes<4>,
                alloy::sol_types::private::Address,
            );
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<constructorCall> for UnderlyingRustTuple<'_> {
                fn from(value: constructorCall) -> Self {
                    (
                        value.riscZeroVerifierRouter,
                        value.riscZeroVerifierSelector,
                        value.emergencyStopCaller,
                    )
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>> for constructorCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self {
                        riscZeroVerifierRouter: tuple.0,
                        riscZeroVerifierSelector: tuple.1,
                        emergencyStopCaller: tuple.2,
                    }
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolConstructor for constructorCall {
            type Parameters<'a> = (
                alloy::sol_types::sol_data::Address,
                alloy::sol_types::sol_data::FixedBytes<4>,
                alloy::sol_types::sol_data::Address,
            );
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::Address as alloy_sol_types::SolType>::tokenize(
                        &self.riscZeroVerifierRouter,
                    ),
                    <alloy::sol_types::sol_data::FixedBytes<
                        4,
                    > as alloy_sol_types::SolType>::tokenize(
                        &self.riscZeroVerifierSelector,
                    ),
                    <alloy::sol_types::sol_data::Address as alloy_sol_types::SolType>::tokenize(
                        &self.emergencyStopCaller,
                    ),
                )
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Function with signature `commitmentCount()` and selector `0xc44956d1`.
```solidity
function commitmentCount() external view returns (uint256 count);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct commitmentCountCall;
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    ///Container type for the return parameters of the [`commitmentCount()`](commitmentCountCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct commitmentCountReturn {
        #[allow(missing_docs)]
        pub count: alloy::sol_types::private::primitives::aliases::U256,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = ();
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = ();
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<commitmentCountCall> for UnderlyingRustTuple<'_> {
                fn from(value: commitmentCountCall) -> Self {
                    ()
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>> for commitmentCountCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::Uint<256>,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (
                alloy::sol_types::private::primitives::aliases::U256,
            );
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<commitmentCountReturn>
            for UnderlyingRustTuple<'_> {
                fn from(value: commitmentCountReturn) -> Self {
                    (value.count,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for commitmentCountReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { count: tuple.0 }
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for commitmentCountCall {
            type Parameters<'a> = ();
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = alloy::sol_types::private::primitives::aliases::U256;
            type ReturnTuple<'a> = (alloy::sol_types::sol_data::Uint<256>,);
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "commitmentCount()";
            const SELECTOR: [u8; 4] = [196u8, 73u8, 86u8, 209u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                (
                    <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::SolType>::tokenize(ret),
                )
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(|r| {
                        let r: commitmentCountReturn = r.into();
                        r.count
                    })
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(|r| {
                        let r: commitmentCountReturn = r.into();
                        r.count
                    })
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Function with signature `commitmentTreeCapacity()` and selector `0xfe18ab91`.
```solidity
function commitmentTreeCapacity() external view returns (uint256 capacity);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct commitmentTreeCapacityCall;
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    ///Container type for the return parameters of the [`commitmentTreeCapacity()`](commitmentTreeCapacityCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct commitmentTreeCapacityReturn {
        #[allow(missing_docs)]
        pub capacity: alloy::sol_types::private::primitives::aliases::U256,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = ();
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = ();
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<commitmentTreeCapacityCall>
            for UnderlyingRustTuple<'_> {
                fn from(value: commitmentTreeCapacityCall) -> Self {
                    ()
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for commitmentTreeCapacityCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::Uint<256>,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (
                alloy::sol_types::private::primitives::aliases::U256,
            );
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<commitmentTreeCapacityReturn>
            for UnderlyingRustTuple<'_> {
                fn from(value: commitmentTreeCapacityReturn) -> Self {
                    (value.capacity,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for commitmentTreeCapacityReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { capacity: tuple.0 }
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for commitmentTreeCapacityCall {
            type Parameters<'a> = ();
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = alloy::sol_types::private::primitives::aliases::U256;
            type ReturnTuple<'a> = (alloy::sol_types::sol_data::Uint<256>,);
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "commitmentTreeCapacity()";
            const SELECTOR: [u8; 4] = [254u8, 24u8, 171u8, 145u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                (
                    <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::SolType>::tokenize(ret),
                )
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(|r| {
                        let r: commitmentTreeCapacityReturn = r.into();
                        r.capacity
                    })
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(|r| {
                        let r: commitmentTreeCapacityReturn = r.into();
                        r.capacity
                    })
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Function with signature `commitmentTreeDepth()` and selector `0xa06056f7`.
```solidity
function commitmentTreeDepth() external view returns (uint8 depth);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct commitmentTreeDepthCall;
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    ///Container type for the return parameters of the [`commitmentTreeDepth()`](commitmentTreeDepthCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct commitmentTreeDepthReturn {
        #[allow(missing_docs)]
        pub depth: u8,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = ();
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = ();
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<commitmentTreeDepthCall>
            for UnderlyingRustTuple<'_> {
                fn from(value: commitmentTreeDepthCall) -> Self {
                    ()
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for commitmentTreeDepthCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::Uint<8>,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (u8,);
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<commitmentTreeDepthReturn>
            for UnderlyingRustTuple<'_> {
                fn from(value: commitmentTreeDepthReturn) -> Self {
                    (value.depth,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for commitmentTreeDepthReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { depth: tuple.0 }
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for commitmentTreeDepthCall {
            type Parameters<'a> = ();
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = u8;
            type ReturnTuple<'a> = (alloy::sol_types::sol_data::Uint<8>,);
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "commitmentTreeDepth()";
            const SELECTOR: [u8; 4] = [160u8, 96u8, 86u8, 247u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                (
                    <alloy::sol_types::sol_data::Uint<
                        8,
                    > as alloy_sol_types::SolType>::tokenize(ret),
                )
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(|r| {
                        let r: commitmentTreeDepthReturn = r.into();
                        r.depth
                    })
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(|r| {
                        let r: commitmentTreeDepthReturn = r.into();
                        r.depth
                    })
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Function with signature `commitmentTreeRootAtIndex(uint256)` and selector `0x31ee6242`.
```solidity
function commitmentTreeRootAtIndex(uint256 index) external view returns (bytes32 root);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct commitmentTreeRootAtIndexCall {
        #[allow(missing_docs)]
        pub index: alloy::sol_types::private::primitives::aliases::U256,
    }
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    ///Container type for the return parameters of the [`commitmentTreeRootAtIndex(uint256)`](commitmentTreeRootAtIndexCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct commitmentTreeRootAtIndexReturn {
        #[allow(missing_docs)]
        pub root: alloy::sol_types::private::FixedBytes<32>,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::Uint<256>,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (
                alloy::sol_types::private::primitives::aliases::U256,
            );
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<commitmentTreeRootAtIndexCall>
            for UnderlyingRustTuple<'_> {
                fn from(value: commitmentTreeRootAtIndexCall) -> Self {
                    (value.index,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for commitmentTreeRootAtIndexCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { index: tuple.0 }
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::FixedBytes<32>,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (alloy::sol_types::private::FixedBytes<32>,);
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<commitmentTreeRootAtIndexReturn>
            for UnderlyingRustTuple<'_> {
                fn from(value: commitmentTreeRootAtIndexReturn) -> Self {
                    (value.root,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for commitmentTreeRootAtIndexReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { root: tuple.0 }
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for commitmentTreeRootAtIndexCall {
            type Parameters<'a> = (alloy::sol_types::sol_data::Uint<256>,);
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = alloy::sol_types::private::FixedBytes<32>;
            type ReturnTuple<'a> = (alloy::sol_types::sol_data::FixedBytes<32>,);
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "commitmentTreeRootAtIndex(uint256)";
            const SELECTOR: [u8; 4] = [49u8, 238u8, 98u8, 66u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::SolType>::tokenize(&self.index),
                )
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                (
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(ret),
                )
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(|r| {
                        let r: commitmentTreeRootAtIndexReturn = r.into();
                        r.root
                    })
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(|r| {
                        let r: commitmentTreeRootAtIndexReturn = r.into();
                        r.root
                    })
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Function with signature `commitmentTreeRootCount()` and selector `0x59ba9258`.
```solidity
function commitmentTreeRootCount() external view returns (uint256 count);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct commitmentTreeRootCountCall;
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    ///Container type for the return parameters of the [`commitmentTreeRootCount()`](commitmentTreeRootCountCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct commitmentTreeRootCountReturn {
        #[allow(missing_docs)]
        pub count: alloy::sol_types::private::primitives::aliases::U256,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = ();
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = ();
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<commitmentTreeRootCountCall>
            for UnderlyingRustTuple<'_> {
                fn from(value: commitmentTreeRootCountCall) -> Self {
                    ()
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for commitmentTreeRootCountCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::Uint<256>,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (
                alloy::sol_types::private::primitives::aliases::U256,
            );
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<commitmentTreeRootCountReturn>
            for UnderlyingRustTuple<'_> {
                fn from(value: commitmentTreeRootCountReturn) -> Self {
                    (value.count,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for commitmentTreeRootCountReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { count: tuple.0 }
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for commitmentTreeRootCountCall {
            type Parameters<'a> = ();
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = alloy::sol_types::private::primitives::aliases::U256;
            type ReturnTuple<'a> = (alloy::sol_types::sol_data::Uint<256>,);
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "commitmentTreeRootCount()";
            const SELECTOR: [u8; 4] = [89u8, 186u8, 146u8, 88u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                (
                    <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::SolType>::tokenize(ret),
                )
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(|r| {
                        let r: commitmentTreeRootCountReturn = r.into();
                        r.count
                    })
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(|r| {
                        let r: commitmentTreeRootCountReturn = r.into();
                        r.count
                    })
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Function with signature `emergencyStop()` and selector `0x63a599a4`.
```solidity
function emergencyStop() external;
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct emergencyStopCall;
    ///Container type for the return parameters of the [`emergencyStop()`](emergencyStopCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct emergencyStopReturn {}
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = ();
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = ();
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<emergencyStopCall> for UnderlyingRustTuple<'_> {
                fn from(value: emergencyStopCall) -> Self {
                    ()
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>> for emergencyStopCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = ();
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = ();
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<emergencyStopReturn> for UnderlyingRustTuple<'_> {
                fn from(value: emergencyStopReturn) -> Self {
                    ()
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>> for emergencyStopReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self {}
                }
            }
        }
        impl emergencyStopReturn {
            fn _tokenize(
                &self,
            ) -> <emergencyStopCall as alloy_sol_types::SolCall>::ReturnToken<'_> {
                ()
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for emergencyStopCall {
            type Parameters<'a> = ();
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = emergencyStopReturn;
            type ReturnTuple<'a> = ();
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "emergencyStop()";
            const SELECTOR: [u8; 4] = [99u8, 165u8, 153u8, 164u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                emergencyStopReturn::_tokenize(ret)
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(Into::into)
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Into::into)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive()]
    /**Function with signature `execute((((bytes32,bytes32,((uint8,bytes)[],(uint8,bytes)[],(uint8,bytes)[],(uint8,bytes)[]),bytes)[],(bytes,((bytes32,bytes32,bytes32),(bytes32,bytes32),bytes32,bytes32))[])[],bytes,bytes))` and selector `0xed3cf91f`.
```solidity
function execute(Transaction memory transaction) external;
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct executeCall {
        #[allow(missing_docs)]
        pub transaction: <Transaction as alloy::sol_types::SolType>::RustType,
    }
    ///Container type for the return parameters of the [`execute((((bytes32,bytes32,((uint8,bytes)[],(uint8,bytes)[],(uint8,bytes)[],(uint8,bytes)[]),bytes)[],(bytes,((bytes32,bytes32,bytes32),(bytes32,bytes32),bytes32,bytes32))[])[],bytes,bytes))`](executeCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct executeReturn {}
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (Transaction,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (
                <Transaction as alloy::sol_types::SolType>::RustType,
            );
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<executeCall> for UnderlyingRustTuple<'_> {
                fn from(value: executeCall) -> Self {
                    (value.transaction,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>> for executeCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { transaction: tuple.0 }
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = ();
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = ();
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<executeReturn> for UnderlyingRustTuple<'_> {
                fn from(value: executeReturn) -> Self {
                    ()
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>> for executeReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self {}
                }
            }
        }
        impl executeReturn {
            fn _tokenize(
                &self,
            ) -> <executeCall as alloy_sol_types::SolCall>::ReturnToken<'_> {
                ()
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for executeCall {
            type Parameters<'a> = (Transaction,);
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = executeReturn;
            type ReturnTuple<'a> = ();
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "execute((((bytes32,bytes32,((uint8,bytes)[],(uint8,bytes)[],(uint8,bytes)[],(uint8,bytes)[]),bytes)[],(bytes,((bytes32,bytes32,bytes32),(bytes32,bytes32),bytes32,bytes32))[])[],bytes,bytes))";
            const SELECTOR: [u8; 4] = [237u8, 60u8, 249u8, 31u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (<Transaction as alloy_sol_types::SolType>::tokenize(&self.transaction),)
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                executeReturn::_tokenize(ret)
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(Into::into)
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Into::into)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Function with signature `getRiscZeroVerifierRouter()` and selector `0x5b666b1e`.
```solidity
function getRiscZeroVerifierRouter() external view returns (address verifierRouter);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct getRiscZeroVerifierRouterCall;
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    ///Container type for the return parameters of the [`getRiscZeroVerifierRouter()`](getRiscZeroVerifierRouterCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct getRiscZeroVerifierRouterReturn {
        #[allow(missing_docs)]
        pub verifierRouter: alloy::sol_types::private::Address,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = ();
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = ();
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<getRiscZeroVerifierRouterCall>
            for UnderlyingRustTuple<'_> {
                fn from(value: getRiscZeroVerifierRouterCall) -> Self {
                    ()
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for getRiscZeroVerifierRouterCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::Address,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (alloy::sol_types::private::Address,);
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<getRiscZeroVerifierRouterReturn>
            for UnderlyingRustTuple<'_> {
                fn from(value: getRiscZeroVerifierRouterReturn) -> Self {
                    (value.verifierRouter,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for getRiscZeroVerifierRouterReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { verifierRouter: tuple.0 }
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for getRiscZeroVerifierRouterCall {
            type Parameters<'a> = ();
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = alloy::sol_types::private::Address;
            type ReturnTuple<'a> = (alloy::sol_types::sol_data::Address,);
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "getRiscZeroVerifierRouter()";
            const SELECTOR: [u8; 4] = [91u8, 102u8, 107u8, 30u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                (
                    <alloy::sol_types::sol_data::Address as alloy_sol_types::SolType>::tokenize(
                        ret,
                    ),
                )
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(|r| {
                        let r: getRiscZeroVerifierRouterReturn = r.into();
                        r.verifierRouter
                    })
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(|r| {
                        let r: getRiscZeroVerifierRouterReturn = r.into();
                        r.verifierRouter
                    })
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Function with signature `getRiscZeroVerifierSelector()` and selector `0xe33845cf`.
```solidity
function getRiscZeroVerifierSelector() external view returns (bytes4 verifierSelector);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct getRiscZeroVerifierSelectorCall;
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    ///Container type for the return parameters of the [`getRiscZeroVerifierSelector()`](getRiscZeroVerifierSelectorCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct getRiscZeroVerifierSelectorReturn {
        #[allow(missing_docs)]
        pub verifierSelector: alloy::sol_types::private::FixedBytes<4>,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = ();
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = ();
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<getRiscZeroVerifierSelectorCall>
            for UnderlyingRustTuple<'_> {
                fn from(value: getRiscZeroVerifierSelectorCall) -> Self {
                    ()
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for getRiscZeroVerifierSelectorCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::FixedBytes<4>,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (alloy::sol_types::private::FixedBytes<4>,);
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<getRiscZeroVerifierSelectorReturn>
            for UnderlyingRustTuple<'_> {
                fn from(value: getRiscZeroVerifierSelectorReturn) -> Self {
                    (value.verifierSelector,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for getRiscZeroVerifierSelectorReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { verifierSelector: tuple.0 }
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for getRiscZeroVerifierSelectorCall {
            type Parameters<'a> = ();
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = alloy::sol_types::private::FixedBytes<4>;
            type ReturnTuple<'a> = (alloy::sol_types::sol_data::FixedBytes<4>,);
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "getRiscZeroVerifierSelector()";
            const SELECTOR: [u8; 4] = [227u8, 56u8, 69u8, 207u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                (
                    <alloy::sol_types::sol_data::FixedBytes<
                        4,
                    > as alloy_sol_types::SolType>::tokenize(ret),
                )
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(|r| {
                        let r: getRiscZeroVerifierSelectorReturn = r.into();
                        r.verifierSelector
                    })
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(|r| {
                        let r: getRiscZeroVerifierSelectorReturn = r.into();
                        r.verifierSelector
                    })
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Function with signature `getVersion()` and selector `0x0d8e6e2c`.
```solidity
function getVersion() external pure returns (bytes32 version);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct getVersionCall;
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    ///Container type for the return parameters of the [`getVersion()`](getVersionCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct getVersionReturn {
        #[allow(missing_docs)]
        pub version: alloy::sol_types::private::FixedBytes<32>,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = ();
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = ();
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<getVersionCall> for UnderlyingRustTuple<'_> {
                fn from(value: getVersionCall) -> Self {
                    ()
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>> for getVersionCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::FixedBytes<32>,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (alloy::sol_types::private::FixedBytes<32>,);
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<getVersionReturn> for UnderlyingRustTuple<'_> {
                fn from(value: getVersionReturn) -> Self {
                    (value.version,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>> for getVersionReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { version: tuple.0 }
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for getVersionCall {
            type Parameters<'a> = ();
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = alloy::sol_types::private::FixedBytes<32>;
            type ReturnTuple<'a> = (alloy::sol_types::sol_data::FixedBytes<32>,);
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "getVersion()";
            const SELECTOR: [u8; 4] = [13u8, 142u8, 110u8, 44u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                (
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(ret),
                )
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(|r| {
                        let r: getVersionReturn = r.into();
                        r.version
                    })
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(|r| {
                        let r: getVersionReturn = r.into();
                        r.version
                    })
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Function with signature `isCommitmentTreeRootContained(bytes32)` and selector `0xc879dbe4`.
```solidity
function isCommitmentTreeRootContained(bytes32 root) external view returns (bool isContained);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct isCommitmentTreeRootContainedCall {
        #[allow(missing_docs)]
        pub root: alloy::sol_types::private::FixedBytes<32>,
    }
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    ///Container type for the return parameters of the [`isCommitmentTreeRootContained(bytes32)`](isCommitmentTreeRootContainedCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct isCommitmentTreeRootContainedReturn {
        #[allow(missing_docs)]
        pub isContained: bool,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::FixedBytes<32>,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (alloy::sol_types::private::FixedBytes<32>,);
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<isCommitmentTreeRootContainedCall>
            for UnderlyingRustTuple<'_> {
                fn from(value: isCommitmentTreeRootContainedCall) -> Self {
                    (value.root,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for isCommitmentTreeRootContainedCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { root: tuple.0 }
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::Bool,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (bool,);
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<isCommitmentTreeRootContainedReturn>
            for UnderlyingRustTuple<'_> {
                fn from(value: isCommitmentTreeRootContainedReturn) -> Self {
                    (value.isContained,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for isCommitmentTreeRootContainedReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { isContained: tuple.0 }
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for isCommitmentTreeRootContainedCall {
            type Parameters<'a> = (alloy::sol_types::sol_data::FixedBytes<32>,);
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = bool;
            type ReturnTuple<'a> = (alloy::sol_types::sol_data::Bool,);
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "isCommitmentTreeRootContained(bytes32)";
            const SELECTOR: [u8; 4] = [200u8, 121u8, 219u8, 228u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.root),
                )
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                (
                    <alloy::sol_types::sol_data::Bool as alloy_sol_types::SolType>::tokenize(
                        ret,
                    ),
                )
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(|r| {
                        let r: isCommitmentTreeRootContainedReturn = r.into();
                        r.isContained
                    })
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(|r| {
                        let r: isCommitmentTreeRootContainedReturn = r.into();
                        r.isContained
                    })
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Function with signature `isEmergencyStopped()` and selector `0xfddd4837`.
```solidity
function isEmergencyStopped() external view returns (bool isStopped);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct isEmergencyStoppedCall;
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    ///Container type for the return parameters of the [`isEmergencyStopped()`](isEmergencyStoppedCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct isEmergencyStoppedReturn {
        #[allow(missing_docs)]
        pub isStopped: bool,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = ();
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = ();
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<isEmergencyStoppedCall>
            for UnderlyingRustTuple<'_> {
                fn from(value: isEmergencyStoppedCall) -> Self {
                    ()
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for isEmergencyStoppedCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::Bool,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (bool,);
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<isEmergencyStoppedReturn>
            for UnderlyingRustTuple<'_> {
                fn from(value: isEmergencyStoppedReturn) -> Self {
                    (value.isStopped,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for isEmergencyStoppedReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { isStopped: tuple.0 }
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for isEmergencyStoppedCall {
            type Parameters<'a> = ();
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = bool;
            type ReturnTuple<'a> = (alloy::sol_types::sol_data::Bool,);
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "isEmergencyStopped()";
            const SELECTOR: [u8; 4] = [253u8, 221u8, 72u8, 55u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                (
                    <alloy::sol_types::sol_data::Bool as alloy_sol_types::SolType>::tokenize(
                        ret,
                    ),
                )
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(|r| {
                        let r: isEmergencyStoppedReturn = r.into();
                        r.isStopped
                    })
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(|r| {
                        let r: isEmergencyStoppedReturn = r.into();
                        r.isStopped
                    })
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Function with signature `isNullifierContained(bytes32)` and selector `0xc1b0bed7`.
```solidity
function isNullifierContained(bytes32 nullifier) external view returns (bool isContained);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct isNullifierContainedCall {
        #[allow(missing_docs)]
        pub nullifier: alloy::sol_types::private::FixedBytes<32>,
    }
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    ///Container type for the return parameters of the [`isNullifierContained(bytes32)`](isNullifierContainedCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct isNullifierContainedReturn {
        #[allow(missing_docs)]
        pub isContained: bool,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::FixedBytes<32>,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (alloy::sol_types::private::FixedBytes<32>,);
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<isNullifierContainedCall>
            for UnderlyingRustTuple<'_> {
                fn from(value: isNullifierContainedCall) -> Self {
                    (value.nullifier,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for isNullifierContainedCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { nullifier: tuple.0 }
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::Bool,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (bool,);
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<isNullifierContainedReturn>
            for UnderlyingRustTuple<'_> {
                fn from(value: isNullifierContainedReturn) -> Self {
                    (value.isContained,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for isNullifierContainedReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { isContained: tuple.0 }
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for isNullifierContainedCall {
            type Parameters<'a> = (alloy::sol_types::sol_data::FixedBytes<32>,);
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = bool;
            type ReturnTuple<'a> = (alloy::sol_types::sol_data::Bool,);
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "isNullifierContained(bytes32)";
            const SELECTOR: [u8; 4] = [193u8, 176u8, 190u8, 215u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(&self.nullifier),
                )
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                (
                    <alloy::sol_types::sol_data::Bool as alloy_sol_types::SolType>::tokenize(
                        ret,
                    ),
                )
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(|r| {
                        let r: isNullifierContainedReturn = r.into();
                        r.isContained
                    })
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(|r| {
                        let r: isNullifierContainedReturn = r.into();
                        r.isContained
                    })
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Function with signature `latestCommitmentTreeRoot()` and selector `0xbdeb442d`.
```solidity
function latestCommitmentTreeRoot() external view returns (bytes32 root);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct latestCommitmentTreeRootCall;
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    ///Container type for the return parameters of the [`latestCommitmentTreeRoot()`](latestCommitmentTreeRootCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct latestCommitmentTreeRootReturn {
        #[allow(missing_docs)]
        pub root: alloy::sol_types::private::FixedBytes<32>,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = ();
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = ();
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<latestCommitmentTreeRootCall>
            for UnderlyingRustTuple<'_> {
                fn from(value: latestCommitmentTreeRootCall) -> Self {
                    ()
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for latestCommitmentTreeRootCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::FixedBytes<32>,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (alloy::sol_types::private::FixedBytes<32>,);
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<latestCommitmentTreeRootReturn>
            for UnderlyingRustTuple<'_> {
                fn from(value: latestCommitmentTreeRootReturn) -> Self {
                    (value.root,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for latestCommitmentTreeRootReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { root: tuple.0 }
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for latestCommitmentTreeRootCall {
            type Parameters<'a> = ();
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = alloy::sol_types::private::FixedBytes<32>;
            type ReturnTuple<'a> = (alloy::sol_types::sol_data::FixedBytes<32>,);
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "latestCommitmentTreeRoot()";
            const SELECTOR: [u8; 4] = [189u8, 235u8, 68u8, 45u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                (
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(ret),
                )
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(|r| {
                        let r: latestCommitmentTreeRootReturn = r.into();
                        r.root
                    })
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(|r| {
                        let r: latestCommitmentTreeRootReturn = r.into();
                        r.root
                    })
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Function with signature `nullifierAtIndex(uint256)` and selector `0x9ad91d4c`.
```solidity
function nullifierAtIndex(uint256 index) external view returns (bytes32 nullifier);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct nullifierAtIndexCall {
        #[allow(missing_docs)]
        pub index: alloy::sol_types::private::primitives::aliases::U256,
    }
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    ///Container type for the return parameters of the [`nullifierAtIndex(uint256)`](nullifierAtIndexCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct nullifierAtIndexReturn {
        #[allow(missing_docs)]
        pub nullifier: alloy::sol_types::private::FixedBytes<32>,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::Uint<256>,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (
                alloy::sol_types::private::primitives::aliases::U256,
            );
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<nullifierAtIndexCall>
            for UnderlyingRustTuple<'_> {
                fn from(value: nullifierAtIndexCall) -> Self {
                    (value.index,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for nullifierAtIndexCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { index: tuple.0 }
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::FixedBytes<32>,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (alloy::sol_types::private::FixedBytes<32>,);
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<nullifierAtIndexReturn>
            for UnderlyingRustTuple<'_> {
                fn from(value: nullifierAtIndexReturn) -> Self {
                    (value.nullifier,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for nullifierAtIndexReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { nullifier: tuple.0 }
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for nullifierAtIndexCall {
            type Parameters<'a> = (alloy::sol_types::sol_data::Uint<256>,);
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = alloy::sol_types::private::FixedBytes<32>;
            type ReturnTuple<'a> = (alloy::sol_types::sol_data::FixedBytes<32>,);
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "nullifierAtIndex(uint256)";
            const SELECTOR: [u8; 4] = [154u8, 217u8, 29u8, 76u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::SolType>::tokenize(&self.index),
                )
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                (
                    <alloy::sol_types::sol_data::FixedBytes<
                        32,
                    > as alloy_sol_types::SolType>::tokenize(ret),
                )
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(|r| {
                        let r: nullifierAtIndexReturn = r.into();
                        r.nullifier
                    })
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(|r| {
                        let r: nullifierAtIndexReturn = r.into();
                        r.nullifier
                    })
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Function with signature `nullifierCount()` and selector `0x40f34d42`.
```solidity
function nullifierCount() external view returns (uint256 count);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct nullifierCountCall;
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    ///Container type for the return parameters of the [`nullifierCount()`](nullifierCountCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct nullifierCountReturn {
        #[allow(missing_docs)]
        pub count: alloy::sol_types::private::primitives::aliases::U256,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = ();
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = ();
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<nullifierCountCall> for UnderlyingRustTuple<'_> {
                fn from(value: nullifierCountCall) -> Self {
                    ()
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>> for nullifierCountCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::Uint<256>,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (
                alloy::sol_types::private::primitives::aliases::U256,
            );
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<nullifierCountReturn>
            for UnderlyingRustTuple<'_> {
                fn from(value: nullifierCountReturn) -> Self {
                    (value.count,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for nullifierCountReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { count: tuple.0 }
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for nullifierCountCall {
            type Parameters<'a> = ();
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = alloy::sol_types::private::primitives::aliases::U256;
            type ReturnTuple<'a> = (alloy::sol_types::sol_data::Uint<256>,);
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "nullifierCount()";
            const SELECTOR: [u8; 4] = [64u8, 243u8, 77u8, 66u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                (
                    <alloy::sol_types::sol_data::Uint<
                        256,
                    > as alloy_sol_types::SolType>::tokenize(ret),
                )
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(|r| {
                        let r: nullifierCountReturn = r.into();
                        r.count
                    })
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(|r| {
                        let r: nullifierCountReturn = r.into();
                        r.count
                    })
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Function with signature `owner()` and selector `0x8da5cb5b`.
```solidity
function owner() external view returns (address);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct ownerCall;
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    ///Container type for the return parameters of the [`owner()`](ownerCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct ownerReturn {
        #[allow(missing_docs)]
        pub _0: alloy::sol_types::private::Address,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = ();
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = ();
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<ownerCall> for UnderlyingRustTuple<'_> {
                fn from(value: ownerCall) -> Self {
                    ()
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>> for ownerCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::Address,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (alloy::sol_types::private::Address,);
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<ownerReturn> for UnderlyingRustTuple<'_> {
                fn from(value: ownerReturn) -> Self {
                    (value._0,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>> for ownerReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { _0: tuple.0 }
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for ownerCall {
            type Parameters<'a> = ();
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = alloy::sol_types::private::Address;
            type ReturnTuple<'a> = (alloy::sol_types::sol_data::Address,);
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "owner()";
            const SELECTOR: [u8; 4] = [141u8, 165u8, 203u8, 91u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                (
                    <alloy::sol_types::sol_data::Address as alloy_sol_types::SolType>::tokenize(
                        ret,
                    ),
                )
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(|r| {
                        let r: ownerReturn = r.into();
                        r._0
                    })
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(|r| {
                        let r: ownerReturn = r.into();
                        r._0
                    })
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Function with signature `paused()` and selector `0x5c975abb`.
```solidity
function paused() external view returns (bool);
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct pausedCall;
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    ///Container type for the return parameters of the [`paused()`](pausedCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct pausedReturn {
        #[allow(missing_docs)]
        pub _0: bool,
    }
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = ();
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = ();
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<pausedCall> for UnderlyingRustTuple<'_> {
                fn from(value: pausedCall) -> Self {
                    ()
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>> for pausedCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::Bool,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (bool,);
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<pausedReturn> for UnderlyingRustTuple<'_> {
                fn from(value: pausedReturn) -> Self {
                    (value._0,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>> for pausedReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { _0: tuple.0 }
                }
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for pausedCall {
            type Parameters<'a> = ();
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = bool;
            type ReturnTuple<'a> = (alloy::sol_types::sol_data::Bool,);
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "paused()";
            const SELECTOR: [u8; 4] = [92u8, 151u8, 90u8, 187u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                (
                    <alloy::sol_types::sol_data::Bool as alloy_sol_types::SolType>::tokenize(
                        ret,
                    ),
                )
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(|r| {
                        let r: pausedReturn = r.into();
                        r._0
                    })
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(|r| {
                        let r: pausedReturn = r.into();
                        r._0
                    })
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Function with signature `renounceOwnership()` and selector `0x715018a6`.
```solidity
function renounceOwnership() external;
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct renounceOwnershipCall;
    ///Container type for the return parameters of the [`renounceOwnership()`](renounceOwnershipCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct renounceOwnershipReturn {}
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = ();
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = ();
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<renounceOwnershipCall>
            for UnderlyingRustTuple<'_> {
                fn from(value: renounceOwnershipCall) -> Self {
                    ()
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for renounceOwnershipCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = ();
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = ();
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<renounceOwnershipReturn>
            for UnderlyingRustTuple<'_> {
                fn from(value: renounceOwnershipReturn) -> Self {
                    ()
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for renounceOwnershipReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self {}
                }
            }
        }
        impl renounceOwnershipReturn {
            fn _tokenize(
                &self,
            ) -> <renounceOwnershipCall as alloy_sol_types::SolCall>::ReturnToken<'_> {
                ()
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for renounceOwnershipCall {
            type Parameters<'a> = ();
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = renounceOwnershipReturn;
            type ReturnTuple<'a> = ();
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "renounceOwnership()";
            const SELECTOR: [u8; 4] = [113u8, 80u8, 24u8, 166u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                ()
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                renounceOwnershipReturn::_tokenize(ret)
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(Into::into)
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Into::into)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive()]
    /**Function with signature `simulateExecute((((bytes32,bytes32,((uint8,bytes)[],(uint8,bytes)[],(uint8,bytes)[],(uint8,bytes)[]),bytes)[],(bytes,((bytes32,bytes32,bytes32),(bytes32,bytes32),bytes32,bytes32))[])[],bytes,bytes),bool)` and selector `0x82d32ad8`.
```solidity
function simulateExecute(Transaction memory transaction, bool skipRiscZeroProofVerification) external;
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct simulateExecuteCall {
        #[allow(missing_docs)]
        pub transaction: <Transaction as alloy::sol_types::SolType>::RustType,
        #[allow(missing_docs)]
        pub skipRiscZeroProofVerification: bool,
    }
    ///Container type for the return parameters of the [`simulateExecute((((bytes32,bytes32,((uint8,bytes)[],(uint8,bytes)[],(uint8,bytes)[],(uint8,bytes)[]),bytes)[],(bytes,((bytes32,bytes32,bytes32),(bytes32,bytes32),bytes32,bytes32))[])[],bytes,bytes),bool)`](simulateExecuteCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct simulateExecuteReturn {}
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (
                Transaction,
                alloy::sol_types::sol_data::Bool,
            );
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (
                <Transaction as alloy::sol_types::SolType>::RustType,
                bool,
            );
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<simulateExecuteCall> for UnderlyingRustTuple<'_> {
                fn from(value: simulateExecuteCall) -> Self {
                    (value.transaction, value.skipRiscZeroProofVerification)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>> for simulateExecuteCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self {
                        transaction: tuple.0,
                        skipRiscZeroProofVerification: tuple.1,
                    }
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = ();
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = ();
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<simulateExecuteReturn>
            for UnderlyingRustTuple<'_> {
                fn from(value: simulateExecuteReturn) -> Self {
                    ()
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for simulateExecuteReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self {}
                }
            }
        }
        impl simulateExecuteReturn {
            fn _tokenize(
                &self,
            ) -> <simulateExecuteCall as alloy_sol_types::SolCall>::ReturnToken<'_> {
                ()
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for simulateExecuteCall {
            type Parameters<'a> = (Transaction, alloy::sol_types::sol_data::Bool);
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = simulateExecuteReturn;
            type ReturnTuple<'a> = ();
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "simulateExecute((((bytes32,bytes32,((uint8,bytes)[],(uint8,bytes)[],(uint8,bytes)[],(uint8,bytes)[]),bytes)[],(bytes,((bytes32,bytes32,bytes32),(bytes32,bytes32),bytes32,bytes32))[])[],bytes,bytes),bool)";
            const SELECTOR: [u8; 4] = [130u8, 211u8, 42u8, 216u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <Transaction as alloy_sol_types::SolType>::tokenize(
                        &self.transaction,
                    ),
                    <alloy::sol_types::sol_data::Bool as alloy_sol_types::SolType>::tokenize(
                        &self.skipRiscZeroProofVerification,
                    ),
                )
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                simulateExecuteReturn::_tokenize(ret)
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(Into::into)
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Into::into)
            }
        }
    };
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Default, Debug, PartialEq, Eq, Hash)]
    /**Function with signature `transferOwnership(address)` and selector `0xf2fde38b`.
```solidity
function transferOwnership(address newOwner) external;
```*/
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct transferOwnershipCall {
        #[allow(missing_docs)]
        pub newOwner: alloy::sol_types::private::Address,
    }
    ///Container type for the return parameters of the [`transferOwnership(address)`](transferOwnershipCall) function.
    #[allow(non_camel_case_types, non_snake_case, clippy::pub_underscore_fields)]
    #[derive(Clone)]
    pub struct transferOwnershipReturn {}
    #[allow(
        non_camel_case_types,
        non_snake_case,
        clippy::pub_underscore_fields,
        clippy::style
    )]
    const _: () = {
        use alloy::sol_types as alloy_sol_types;
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = (alloy::sol_types::sol_data::Address,);
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = (alloy::sol_types::private::Address,);
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<transferOwnershipCall>
            for UnderlyingRustTuple<'_> {
                fn from(value: transferOwnershipCall) -> Self {
                    (value.newOwner,)
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for transferOwnershipCall {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self { newOwner: tuple.0 }
                }
            }
        }
        {
            #[doc(hidden)]
            #[allow(dead_code)]
            type UnderlyingSolTuple<'a> = ();
            #[doc(hidden)]
            type UnderlyingRustTuple<'a> = ();
            #[cfg(test)]
            #[allow(dead_code, unreachable_patterns)]
            fn _type_assertion(
                _t: alloy_sol_types::private::AssertTypeEq<UnderlyingRustTuple>,
            ) {
                match _t {
                    alloy_sol_types::private::AssertTypeEq::<
                        <UnderlyingSolTuple as alloy_sol_types::SolType>::RustType,
                    >(_) => {}
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<transferOwnershipReturn>
            for UnderlyingRustTuple<'_> {
                fn from(value: transferOwnershipReturn) -> Self {
                    ()
                }
            }
            #[automatically_derived]
            #[doc(hidden)]
            impl ::core::convert::From<UnderlyingRustTuple<'_>>
            for transferOwnershipReturn {
                fn from(tuple: UnderlyingRustTuple<'_>) -> Self {
                    Self {}
                }
            }
        }
        impl transferOwnershipReturn {
            fn _tokenize(
                &self,
            ) -> <transferOwnershipCall as alloy_sol_types::SolCall>::ReturnToken<'_> {
                ()
            }
        }
        #[automatically_derived]
        impl alloy_sol_types::SolCall for transferOwnershipCall {
            type Parameters<'a> = (alloy::sol_types::sol_data::Address,);
            type Token<'a> = <Self::Parameters<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            type Return = transferOwnershipReturn;
            type ReturnTuple<'a> = ();
            type ReturnToken<'a> = <Self::ReturnTuple<
                'a,
            > as alloy_sol_types::SolType>::Token<'a>;
            const SIGNATURE: &'static str = "transferOwnership(address)";
            const SELECTOR: [u8; 4] = [242u8, 253u8, 227u8, 139u8];
            #[inline]
            fn new<'a>(
                tuple: <Self::Parameters<'a> as alloy_sol_types::SolType>::RustType,
            ) -> Self {
                tuple.into()
            }
            #[inline]
            fn tokenize(&self) -> Self::Token<'_> {
                (
                    <alloy::sol_types::sol_data::Address as alloy_sol_types::SolType>::tokenize(
                        &self.newOwner,
                    ),
                )
            }
            #[inline]
            fn tokenize_returns(ret: &Self::Return) -> Self::ReturnToken<'_> {
                transferOwnershipReturn::_tokenize(ret)
            }
            #[inline]
            fn abi_decode_returns(data: &[u8]) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence(data)
                    .map(Into::into)
            }
            #[inline]
            fn abi_decode_returns_validate(
                data: &[u8],
            ) -> alloy_sol_types::Result<Self::Return> {
                <Self::ReturnTuple<
                    '_,
                > as alloy_sol_types::SolType>::abi_decode_sequence_validate(data)
                    .map(Into::into)
            }
        }
    };
    ///Container for all the [`ProtocolAdapter`](self) function calls.
    #[derive(Clone)]
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive()]
    pub enum ProtocolAdapterCalls {
        #[allow(missing_docs)]
        commitmentCount(commitmentCountCall),
        #[allow(missing_docs)]
        commitmentTreeCapacity(commitmentTreeCapacityCall),
        #[allow(missing_docs)]
        commitmentTreeDepth(commitmentTreeDepthCall),
        #[allow(missing_docs)]
        commitmentTreeRootAtIndex(commitmentTreeRootAtIndexCall),
        #[allow(missing_docs)]
        commitmentTreeRootCount(commitmentTreeRootCountCall),
        #[allow(missing_docs)]
        emergencyStop(emergencyStopCall),
        #[allow(missing_docs)]
        execute(executeCall),
        #[allow(missing_docs)]
        getRiscZeroVerifierRouter(getRiscZeroVerifierRouterCall),
        #[allow(missing_docs)]
        getRiscZeroVerifierSelector(getRiscZeroVerifierSelectorCall),
        #[allow(missing_docs)]
        getVersion(getVersionCall),
        #[allow(missing_docs)]
        isCommitmentTreeRootContained(isCommitmentTreeRootContainedCall),
        #[allow(missing_docs)]
        isEmergencyStopped(isEmergencyStoppedCall),
        #[allow(missing_docs)]
        isNullifierContained(isNullifierContainedCall),
        #[allow(missing_docs)]
        latestCommitmentTreeRoot(latestCommitmentTreeRootCall),
        #[allow(missing_docs)]
        nullifierAtIndex(nullifierAtIndexCall),
        #[allow(missing_docs)]
        nullifierCount(nullifierCountCall),
        #[allow(missing_docs)]
        owner(ownerCall),
        #[allow(missing_docs)]
        paused(pausedCall),
        #[allow(missing_docs)]
        renounceOwnership(renounceOwnershipCall),
        #[allow(missing_docs)]
        simulateExecute(simulateExecuteCall),
        #[allow(missing_docs)]
        transferOwnership(transferOwnershipCall),
    }
    impl ProtocolAdapterCalls {
        /// All the selectors of this enum.
        ///
        /// Note that the selectors might not be in the same order as the variants.
        /// No guarantees are made about the order of the selectors.
        ///
        /// Prefer using `SolInterface` methods instead.
        pub const SELECTORS: &'static [[u8; 4usize]] = &[
            [13u8, 142u8, 110u8, 44u8],
            [49u8, 238u8, 98u8, 66u8],
            [64u8, 243u8, 77u8, 66u8],
            [89u8, 186u8, 146u8, 88u8],
            [91u8, 102u8, 107u8, 30u8],
            [92u8, 151u8, 90u8, 187u8],
            [99u8, 165u8, 153u8, 164u8],
            [113u8, 80u8, 24u8, 166u8],
            [130u8, 211u8, 42u8, 216u8],
            [141u8, 165u8, 203u8, 91u8],
            [154u8, 217u8, 29u8, 76u8],
            [160u8, 96u8, 86u8, 247u8],
            [189u8, 235u8, 68u8, 45u8],
            [193u8, 176u8, 190u8, 215u8],
            [196u8, 73u8, 86u8, 209u8],
            [200u8, 121u8, 219u8, 228u8],
            [227u8, 56u8, 69u8, 207u8],
            [237u8, 60u8, 249u8, 31u8],
            [242u8, 253u8, 227u8, 139u8],
            [253u8, 221u8, 72u8, 55u8],
            [254u8, 24u8, 171u8, 145u8],
        ];
        /// The names of the variants in the same order as `SELECTORS`.
        pub const VARIANT_NAMES: &'static [&'static str] = &[
            ::core::stringify!(getVersion),
            ::core::stringify!(commitmentTreeRootAtIndex),
            ::core::stringify!(nullifierCount),
            ::core::stringify!(commitmentTreeRootCount),
            ::core::stringify!(getRiscZeroVerifierRouter),
            ::core::stringify!(paused),
            ::core::stringify!(emergencyStop),
            ::core::stringify!(renounceOwnership),
            ::core::stringify!(simulateExecute),
            ::core::stringify!(owner),
            ::core::stringify!(nullifierAtIndex),
            ::core::stringify!(commitmentTreeDepth),
            ::core::stringify!(latestCommitmentTreeRoot),
            ::core::stringify!(isNullifierContained),
            ::core::stringify!(commitmentCount),
            ::core::stringify!(isCommitmentTreeRootContained),
            ::core::stringify!(getRiscZeroVerifierSelector),
            ::core::stringify!(execute),
            ::core::stringify!(transferOwnership),
            ::core::stringify!(isEmergencyStopped),
            ::core::stringify!(commitmentTreeCapacity),
        ];
        /// The signatures in the same order as `SELECTORS`.
        pub const SIGNATURES: &'static [&'static str] = &[
            <getVersionCall as alloy_sol_types::SolCall>::SIGNATURE,
            <commitmentTreeRootAtIndexCall as alloy_sol_types::SolCall>::SIGNATURE,
            <nullifierCountCall as alloy_sol_types::SolCall>::SIGNATURE,
            <commitmentTreeRootCountCall as alloy_sol_types::SolCall>::SIGNATURE,
            <getRiscZeroVerifierRouterCall as alloy_sol_types::SolCall>::SIGNATURE,
            <pausedCall as alloy_sol_types::SolCall>::SIGNATURE,
            <emergencyStopCall as alloy_sol_types::SolCall>::SIGNATURE,
            <renounceOwnershipCall as alloy_sol_types::SolCall>::SIGNATURE,
            <simulateExecuteCall as alloy_sol_types::SolCall>::SIGNATURE,
            <ownerCall as alloy_sol_types::SolCall>::SIGNATURE,
            <nullifierAtIndexCall as alloy_sol_types::SolCall>::SIGNATURE,
            <commitmentTreeDepthCall as alloy_sol_types::SolCall>::SIGNATURE,
            <latestCommitmentTreeRootCall as alloy_sol_types::SolCall>::SIGNATURE,
            <isNullifierContainedCall as alloy_sol_types::SolCall>::SIGNATURE,
            <commitmentCountCall as alloy_sol_types::SolCall>::SIGNATURE,
            <isCommitmentTreeRootContainedCall as alloy_sol_types::SolCall>::SIGNATURE,
            <getRiscZeroVerifierSelectorCall as alloy_sol_types::SolCall>::SIGNATURE,
            <executeCall as alloy_sol_types::SolCall>::SIGNATURE,
            <transferOwnershipCall as alloy_sol_types::SolCall>::SIGNATURE,
            <isEmergencyStoppedCall as alloy_sol_types::SolCall>::SIGNATURE,
            <commitmentTreeCapacityCall as alloy_sol_types::SolCall>::SIGNATURE,
        ];
        /// Returns the signature for the given selector, if known.
        #[inline]
        pub fn signature_by_selector(
            selector: [u8; 4usize],
        ) -> ::core::option::Option<&'static str> {
            match Self::SELECTORS.binary_search(&selector) {
                ::core::result::Result::Ok(idx) => {
                    ::core::option::Option::Some(Self::SIGNATURES[idx])
                }
                ::core::result::Result::Err(_) => ::core::option::Option::None,
            }
        }
        /// Returns the enum variant name for the given selector, if known.
        #[inline]
        pub fn name_by_selector(
            selector: [u8; 4usize],
        ) -> ::core::option::Option<&'static str> {
            let sig = Self::signature_by_selector(selector)?;
            sig.split_once('(').map(|(name, _)| name)
        }
    }
    #[automatically_derived]
    impl alloy_sol_types::SolInterface for ProtocolAdapterCalls {
        const NAME: &'static str = "ProtocolAdapterCalls";
        const MIN_DATA_LENGTH: usize = 0usize;
        const COUNT: usize = 21usize;
        #[inline]
        fn selector(&self) -> [u8; 4] {
            match self {
                Self::commitmentCount(_) => {
                    <commitmentCountCall as alloy_sol_types::SolCall>::SELECTOR
                }
                Self::commitmentTreeCapacity(_) => {
                    <commitmentTreeCapacityCall as alloy_sol_types::SolCall>::SELECTOR
                }
                Self::commitmentTreeDepth(_) => {
                    <commitmentTreeDepthCall as alloy_sol_types::SolCall>::SELECTOR
                }
                Self::commitmentTreeRootAtIndex(_) => {
                    <commitmentTreeRootAtIndexCall as alloy_sol_types::SolCall>::SELECTOR
                }
                Self::commitmentTreeRootCount(_) => {
                    <commitmentTreeRootCountCall as alloy_sol_types::SolCall>::SELECTOR
                }
                Self::emergencyStop(_) => {
                    <emergencyStopCall as alloy_sol_types::SolCall>::SELECTOR
                }
                Self::execute(_) => <executeCall as alloy_sol_types::SolCall>::SELECTOR,
                Self::getRiscZeroVerifierRouter(_) => {
                    <getRiscZeroVerifierRouterCall as alloy_sol_types::SolCall>::SELECTOR
                }
                Self::getRiscZeroVerifierSelector(_) => {
                    <getRiscZeroVerifierSelectorCall as alloy_sol_types::SolCall>::SELECTOR
                }
                Self::getVersion(_) => {
                    <getVersionCall as alloy_sol_types::SolCall>::SELECTOR
                }
                Self::isCommitmentTreeRootContained(_) => {
                    <isCommitmentTreeRootContainedCall as alloy_sol_types::SolCall>::SELECTOR
                }
                Self::isEmergencyStopped(_) => {
                    <isEmergencyStoppedCall as alloy_sol_types::SolCall>::SELECTOR
                }
                Self::isNullifierContained(_) => {
                    <isNullifierContainedCall as alloy_sol_types::SolCall>::SELECTOR
                }
                Self::latestCommitmentTreeRoot(_) => {
                    <latestCommitmentTreeRootCall as alloy_sol_types::SolCall>::SELECTOR
                }
                Self::nullifierAtIndex(_) => {
                    <nullifierAtIndexCall as alloy_sol_types::SolCall>::SELECTOR
                }
                Self::nullifierCount(_) => {
                    <nullifierCountCall as alloy_sol_types::SolCall>::SELECTOR
                }
                Self::owner(_) => <ownerCall as alloy_sol_types::SolCall>::SELECTOR,
                Self::paused(_) => <pausedCall as alloy_sol_types::SolCall>::SELECTOR,
                Self::renounceOwnership(_) => {
                    <renounceOwnershipCall as alloy_sol_types::SolCall>::SELECTOR
                }
                Self::simulateExecute(_) => {
                    <simulateExecuteCall as alloy_sol_types::SolCall>::SELECTOR
                }
                Self::transferOwnership(_) => {
                    <transferOwnershipCall as alloy_sol_types::SolCall>::SELECTOR
                }
            }
        }
        #[inline]
        fn selector_at(i: usize) -> ::core::option::Option<[u8; 4]> {
            Self::SELECTORS.get(i).copied()
        }
        #[inline]
        fn valid_selector(selector: [u8; 4]) -> bool {
            Self::SELECTORS.binary_search(&selector).is_ok()
        }
        #[inline]
        #[allow(non_snake_case)]
        fn abi_decode_raw(
            selector: [u8; 4],
            data: &[u8],
        ) -> alloy_sol_types::Result<Self> {
            static DECODE_SHIMS: &[fn(
                &[u8],
            ) -> alloy_sol_types::Result<ProtocolAdapterCalls>] = &[
                {
                    fn getVersion(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <getVersionCall as alloy_sol_types::SolCall>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterCalls::getVersion)
                    }
                    getVersion
                },
                {
                    fn commitmentTreeRootAtIndex(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <commitmentTreeRootAtIndexCall as alloy_sol_types::SolCall>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterCalls::commitmentTreeRootAtIndex)
                    }
                    commitmentTreeRootAtIndex
                },
                {
                    fn nullifierCount(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <nullifierCountCall as alloy_sol_types::SolCall>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterCalls::nullifierCount)
                    }
                    nullifierCount
                },
                {
                    fn commitmentTreeRootCount(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <commitmentTreeRootCountCall as alloy_sol_types::SolCall>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterCalls::commitmentTreeRootCount)
                    }
                    commitmentTreeRootCount
                },
                {
                    fn getRiscZeroVerifierRouter(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <getRiscZeroVerifierRouterCall as alloy_sol_types::SolCall>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterCalls::getRiscZeroVerifierRouter)
                    }
                    getRiscZeroVerifierRouter
                },
                {
                    fn paused(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <pausedCall as alloy_sol_types::SolCall>::abi_decode_raw(data)
                            .map(ProtocolAdapterCalls::paused)
                    }
                    paused
                },
                {
                    fn emergencyStop(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <emergencyStopCall as alloy_sol_types::SolCall>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterCalls::emergencyStop)
                    }
                    emergencyStop
                },
                {
                    fn renounceOwnership(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <renounceOwnershipCall as alloy_sol_types::SolCall>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterCalls::renounceOwnership)
                    }
                    renounceOwnership
                },
                {
                    fn simulateExecute(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <simulateExecuteCall as alloy_sol_types::SolCall>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterCalls::simulateExecute)
                    }
                    simulateExecute
                },
                {
                    fn owner(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <ownerCall as alloy_sol_types::SolCall>::abi_decode_raw(data)
                            .map(ProtocolAdapterCalls::owner)
                    }
                    owner
                },
                {
                    fn nullifierAtIndex(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <nullifierAtIndexCall as alloy_sol_types::SolCall>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterCalls::nullifierAtIndex)
                    }
                    nullifierAtIndex
                },
                {
                    fn commitmentTreeDepth(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <commitmentTreeDepthCall as alloy_sol_types::SolCall>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterCalls::commitmentTreeDepth)
                    }
                    commitmentTreeDepth
                },
                {
                    fn latestCommitmentTreeRoot(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <latestCommitmentTreeRootCall as alloy_sol_types::SolCall>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterCalls::latestCommitmentTreeRoot)
                    }
                    latestCommitmentTreeRoot
                },
                {
                    fn isNullifierContained(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <isNullifierContainedCall as alloy_sol_types::SolCall>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterCalls::isNullifierContained)
                    }
                    isNullifierContained
                },
                {
                    fn commitmentCount(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <commitmentCountCall as alloy_sol_types::SolCall>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterCalls::commitmentCount)
                    }
                    commitmentCount
                },
                {
                    fn isCommitmentTreeRootContained(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <isCommitmentTreeRootContainedCall as alloy_sol_types::SolCall>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterCalls::isCommitmentTreeRootContained)
                    }
                    isCommitmentTreeRootContained
                },
                {
                    fn getRiscZeroVerifierSelector(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <getRiscZeroVerifierSelectorCall as alloy_sol_types::SolCall>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterCalls::getRiscZeroVerifierSelector)
                    }
                    getRiscZeroVerifierSelector
                },
                {
                    fn execute(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <executeCall as alloy_sol_types::SolCall>::abi_decode_raw(data)
                            .map(ProtocolAdapterCalls::execute)
                    }
                    execute
                },
                {
                    fn transferOwnership(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <transferOwnershipCall as alloy_sol_types::SolCall>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterCalls::transferOwnership)
                    }
                    transferOwnership
                },
                {
                    fn isEmergencyStopped(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <isEmergencyStoppedCall as alloy_sol_types::SolCall>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterCalls::isEmergencyStopped)
                    }
                    isEmergencyStopped
                },
                {
                    fn commitmentTreeCapacity(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <commitmentTreeCapacityCall as alloy_sol_types::SolCall>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterCalls::commitmentTreeCapacity)
                    }
                    commitmentTreeCapacity
                },
            ];
            let Ok(idx) = Self::SELECTORS.binary_search(&selector) else {
                return Err(
                    alloy_sol_types::Error::unknown_selector(
                        <Self as alloy_sol_types::SolInterface>::NAME,
                        selector,
                    ),
                );
            };
            DECODE_SHIMS[idx](data)
        }
        #[inline]
        #[allow(non_snake_case)]
        fn abi_decode_raw_validate(
            selector: [u8; 4],
            data: &[u8],
        ) -> alloy_sol_types::Result<Self> {
            static DECODE_VALIDATE_SHIMS: &[fn(
                &[u8],
            ) -> alloy_sol_types::Result<ProtocolAdapterCalls>] = &[
                {
                    fn getVersion(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <getVersionCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::getVersion)
                    }
                    getVersion
                },
                {
                    fn commitmentTreeRootAtIndex(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <commitmentTreeRootAtIndexCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::commitmentTreeRootAtIndex)
                    }
                    commitmentTreeRootAtIndex
                },
                {
                    fn nullifierCount(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <nullifierCountCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::nullifierCount)
                    }
                    nullifierCount
                },
                {
                    fn commitmentTreeRootCount(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <commitmentTreeRootCountCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::commitmentTreeRootCount)
                    }
                    commitmentTreeRootCount
                },
                {
                    fn getRiscZeroVerifierRouter(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <getRiscZeroVerifierRouterCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::getRiscZeroVerifierRouter)
                    }
                    getRiscZeroVerifierRouter
                },
                {
                    fn paused(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <pausedCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::paused)
                    }
                    paused
                },
                {
                    fn emergencyStop(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <emergencyStopCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::emergencyStop)
                    }
                    emergencyStop
                },
                {
                    fn renounceOwnership(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <renounceOwnershipCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::renounceOwnership)
                    }
                    renounceOwnership
                },
                {
                    fn simulateExecute(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <simulateExecuteCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::simulateExecute)
                    }
                    simulateExecute
                },
                {
                    fn owner(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <ownerCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::owner)
                    }
                    owner
                },
                {
                    fn nullifierAtIndex(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <nullifierAtIndexCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::nullifierAtIndex)
                    }
                    nullifierAtIndex
                },
                {
                    fn commitmentTreeDepth(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <commitmentTreeDepthCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::commitmentTreeDepth)
                    }
                    commitmentTreeDepth
                },
                {
                    fn latestCommitmentTreeRoot(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <latestCommitmentTreeRootCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::latestCommitmentTreeRoot)
                    }
                    latestCommitmentTreeRoot
                },
                {
                    fn isNullifierContained(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <isNullifierContainedCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::isNullifierContained)
                    }
                    isNullifierContained
                },
                {
                    fn commitmentCount(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <commitmentCountCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::commitmentCount)
                    }
                    commitmentCount
                },
                {
                    fn isCommitmentTreeRootContained(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <isCommitmentTreeRootContainedCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::isCommitmentTreeRootContained)
                    }
                    isCommitmentTreeRootContained
                },
                {
                    fn getRiscZeroVerifierSelector(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <getRiscZeroVerifierSelectorCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::getRiscZeroVerifierSelector)
                    }
                    getRiscZeroVerifierSelector
                },
                {
                    fn execute(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <executeCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::execute)
                    }
                    execute
                },
                {
                    fn transferOwnership(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <transferOwnershipCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::transferOwnership)
                    }
                    transferOwnership
                },
                {
                    fn isEmergencyStopped(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <isEmergencyStoppedCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::isEmergencyStopped)
                    }
                    isEmergencyStopped
                },
                {
                    fn commitmentTreeCapacity(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterCalls> {
                        <commitmentTreeCapacityCall as alloy_sol_types::SolCall>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterCalls::commitmentTreeCapacity)
                    }
                    commitmentTreeCapacity
                },
            ];
            let Ok(idx) = Self::SELECTORS.binary_search(&selector) else {
                return Err(
                    alloy_sol_types::Error::unknown_selector(
                        <Self as alloy_sol_types::SolInterface>::NAME,
                        selector,
                    ),
                );
            };
            DECODE_VALIDATE_SHIMS[idx](data)
        }
        #[inline]
        fn abi_encoded_size(&self) -> usize {
            match self {
                Self::commitmentCount(inner) => {
                    <commitmentCountCall as alloy_sol_types::SolCall>::abi_encoded_size(
                        inner,
                    )
                }
                Self::commitmentTreeCapacity(inner) => {
                    <commitmentTreeCapacityCall as alloy_sol_types::SolCall>::abi_encoded_size(
                        inner,
                    )
                }
                Self::commitmentTreeDepth(inner) => {
                    <commitmentTreeDepthCall as alloy_sol_types::SolCall>::abi_encoded_size(
                        inner,
                    )
                }
                Self::commitmentTreeRootAtIndex(inner) => {
                    <commitmentTreeRootAtIndexCall as alloy_sol_types::SolCall>::abi_encoded_size(
                        inner,
                    )
                }
                Self::commitmentTreeRootCount(inner) => {
                    <commitmentTreeRootCountCall as alloy_sol_types::SolCall>::abi_encoded_size(
                        inner,
                    )
                }
                Self::emergencyStop(inner) => {
                    <emergencyStopCall as alloy_sol_types::SolCall>::abi_encoded_size(
                        inner,
                    )
                }
                Self::execute(inner) => {
                    <executeCall as alloy_sol_types::SolCall>::abi_encoded_size(inner)
                }
                Self::getRiscZeroVerifierRouter(inner) => {
                    <getRiscZeroVerifierRouterCall as alloy_sol_types::SolCall>::abi_encoded_size(
                        inner,
                    )
                }
                Self::getRiscZeroVerifierSelector(inner) => {
                    <getRiscZeroVerifierSelectorCall as alloy_sol_types::SolCall>::abi_encoded_size(
                        inner,
                    )
                }
                Self::getVersion(inner) => {
                    <getVersionCall as alloy_sol_types::SolCall>::abi_encoded_size(inner)
                }
                Self::isCommitmentTreeRootContained(inner) => {
                    <isCommitmentTreeRootContainedCall as alloy_sol_types::SolCall>::abi_encoded_size(
                        inner,
                    )
                }
                Self::isEmergencyStopped(inner) => {
                    <isEmergencyStoppedCall as alloy_sol_types::SolCall>::abi_encoded_size(
                        inner,
                    )
                }
                Self::isNullifierContained(inner) => {
                    <isNullifierContainedCall as alloy_sol_types::SolCall>::abi_encoded_size(
                        inner,
                    )
                }
                Self::latestCommitmentTreeRoot(inner) => {
                    <latestCommitmentTreeRootCall as alloy_sol_types::SolCall>::abi_encoded_size(
                        inner,
                    )
                }
                Self::nullifierAtIndex(inner) => {
                    <nullifierAtIndexCall as alloy_sol_types::SolCall>::abi_encoded_size(
                        inner,
                    )
                }
                Self::nullifierCount(inner) => {
                    <nullifierCountCall as alloy_sol_types::SolCall>::abi_encoded_size(
                        inner,
                    )
                }
                Self::owner(inner) => {
                    <ownerCall as alloy_sol_types::SolCall>::abi_encoded_size(inner)
                }
                Self::paused(inner) => {
                    <pausedCall as alloy_sol_types::SolCall>::abi_encoded_size(inner)
                }
                Self::renounceOwnership(inner) => {
                    <renounceOwnershipCall as alloy_sol_types::SolCall>::abi_encoded_size(
                        inner,
                    )
                }
                Self::simulateExecute(inner) => {
                    <simulateExecuteCall as alloy_sol_types::SolCall>::abi_encoded_size(
                        inner,
                    )
                }
                Self::transferOwnership(inner) => {
                    <transferOwnershipCall as alloy_sol_types::SolCall>::abi_encoded_size(
                        inner,
                    )
                }
            }
        }
        #[inline]
        fn abi_encode_raw(&self, out: &mut alloy_sol_types::private::Vec<u8>) {
            match self {
                Self::commitmentCount(inner) => {
                    <commitmentCountCall as alloy_sol_types::SolCall>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::commitmentTreeCapacity(inner) => {
                    <commitmentTreeCapacityCall as alloy_sol_types::SolCall>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::commitmentTreeDepth(inner) => {
                    <commitmentTreeDepthCall as alloy_sol_types::SolCall>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::commitmentTreeRootAtIndex(inner) => {
                    <commitmentTreeRootAtIndexCall as alloy_sol_types::SolCall>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::commitmentTreeRootCount(inner) => {
                    <commitmentTreeRootCountCall as alloy_sol_types::SolCall>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::emergencyStop(inner) => {
                    <emergencyStopCall as alloy_sol_types::SolCall>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::execute(inner) => {
                    <executeCall as alloy_sol_types::SolCall>::abi_encode_raw(inner, out)
                }
                Self::getRiscZeroVerifierRouter(inner) => {
                    <getRiscZeroVerifierRouterCall as alloy_sol_types::SolCall>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::getRiscZeroVerifierSelector(inner) => {
                    <getRiscZeroVerifierSelectorCall as alloy_sol_types::SolCall>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::getVersion(inner) => {
                    <getVersionCall as alloy_sol_types::SolCall>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::isCommitmentTreeRootContained(inner) => {
                    <isCommitmentTreeRootContainedCall as alloy_sol_types::SolCall>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::isEmergencyStopped(inner) => {
                    <isEmergencyStoppedCall as alloy_sol_types::SolCall>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::isNullifierContained(inner) => {
                    <isNullifierContainedCall as alloy_sol_types::SolCall>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::latestCommitmentTreeRoot(inner) => {
                    <latestCommitmentTreeRootCall as alloy_sol_types::SolCall>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::nullifierAtIndex(inner) => {
                    <nullifierAtIndexCall as alloy_sol_types::SolCall>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::nullifierCount(inner) => {
                    <nullifierCountCall as alloy_sol_types::SolCall>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::owner(inner) => {
                    <ownerCall as alloy_sol_types::SolCall>::abi_encode_raw(inner, out)
                }
                Self::paused(inner) => {
                    <pausedCall as alloy_sol_types::SolCall>::abi_encode_raw(inner, out)
                }
                Self::renounceOwnership(inner) => {
                    <renounceOwnershipCall as alloy_sol_types::SolCall>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::simulateExecute(inner) => {
                    <simulateExecuteCall as alloy_sol_types::SolCall>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::transferOwnership(inner) => {
                    <transferOwnershipCall as alloy_sol_types::SolCall>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
            }
        }
    }
    ///Container for all the [`ProtocolAdapter`](self) custom errors.
    #[derive(Clone)]
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Debug, PartialEq, Eq, Hash)]
    pub enum ProtocolAdapterErrors {
        #[allow(missing_docs)]
        DeltaMismatch(DeltaMismatch),
        #[allow(missing_docs)]
        ECDSAInvalidSignature(ECDSAInvalidSignature),
        #[allow(missing_docs)]
        ECDSAInvalidSignatureLength(ECDSAInvalidSignatureLength),
        #[allow(missing_docs)]
        ECDSAInvalidSignatureS(ECDSAInvalidSignatureS),
        #[allow(missing_docs)]
        EnforcedPause(EnforcedPause),
        #[allow(missing_docs)]
        ExpectedPause(ExpectedPause),
        #[allow(missing_docs)]
        ForwarderCallOutputMismatch(ForwarderCallOutputMismatch),
        #[allow(missing_docs)]
        LogicRefMismatch(LogicRefMismatch),
        #[allow(missing_docs)]
        NonExistingRoot(NonExistingRoot),
        #[allow(missing_docs)]
        OwnableInvalidOwner(OwnableInvalidOwner),
        #[allow(missing_docs)]
        OwnableUnauthorizedAccount(OwnableUnauthorizedAccount),
        #[allow(missing_docs)]
        PointNotOnCurve(PointNotOnCurve),
        #[allow(missing_docs)]
        PreExistingNullifier(PreExistingNullifier),
        #[allow(missing_docs)]
        PreExistingRoot(PreExistingRoot),
        #[allow(missing_docs)]
        ReentrancyGuardReentrantCall(ReentrancyGuardReentrantCall),
        #[allow(missing_docs)]
        RiscZeroVerifierSelectorMismatch(RiscZeroVerifierSelectorMismatch),
        #[allow(missing_docs)]
        RiscZeroVerifierStopped(RiscZeroVerifierStopped),
        #[allow(missing_docs)]
        Simulated(Simulated),
        #[allow(missing_docs)]
        TagCountMismatch(TagCountMismatch),
        #[allow(missing_docs)]
        TagNotFound(TagNotFound),
        #[allow(missing_docs)]
        ZeroNotAllowed(ZeroNotAllowed),
    }
    impl ProtocolAdapterErrors {
        /// All the selectors of this enum.
        ///
        /// Note that the selectors might not be in the same order as the variants.
        /// No guarantees are made about the order of the selectors.
        ///
        /// Prefer using `SolInterface` methods instead.
        pub const SELECTORS: &'static [[u8; 4usize]] = &[
            [11u8, 29u8, 56u8, 163u8],
            [17u8, 140u8, 218u8, 167u8],
            [24u8, 246u8, 57u8, 216u8],
            [30u8, 79u8, 189u8, 247u8],
            [57u8, 169u8, 64u8, 197u8],
            [62u8, 229u8, 174u8, 181u8],
            [111u8, 20u8, 152u8, 49u8],
            [120u8, 162u8, 34u8, 28u8],
            [137u8, 33u8, 20u8, 116u8],
            [141u8, 252u8, 32u8, 43u8],
            [184u8, 160u8, 232u8, 161u8],
            [197u8, 4u8, 250u8, 218u8],
            [207u8, 75u8, 78u8, 46u8],
            [211u8, 190u8, 231u8, 141u8],
            [215u8, 139u8, 206u8, 12u8],
            [217u8, 60u8, 6u8, 101u8],
            [219u8, 120u8, 140u8, 43u8],
            [230u8, 212u8, 75u8, 76u8],
            [246u8, 69u8, 238u8, 223u8],
            [249u8, 132u8, 158u8, 163u8],
            [252u8, 230u8, 152u8, 247u8],
        ];
        /// The names of the variants in the same order as `SELECTORS`.
        pub const VARIANT_NAMES: &'static [&'static str] = &[
            ::core::stringify!(RiscZeroVerifierStopped),
            ::core::stringify!(OwnableUnauthorizedAccount),
            ::core::stringify!(LogicRefMismatch),
            ::core::stringify!(OwnableInvalidOwner),
            ::core::stringify!(PreExistingNullifier),
            ::core::stringify!(ReentrancyGuardReentrantCall),
            ::core::stringify!(Simulated),
            ::core::stringify!(RiscZeroVerifierSelectorMismatch),
            ::core::stringify!(TagNotFound),
            ::core::stringify!(ExpectedPause),
            ::core::stringify!(PointNotOnCurve),
            ::core::stringify!(ForwarderCallOutputMismatch),
            ::core::stringify!(ZeroNotAllowed),
            ::core::stringify!(TagCountMismatch),
            ::core::stringify!(ECDSAInvalidSignatureS),
            ::core::stringify!(EnforcedPause),
            ::core::stringify!(PreExistingRoot),
            ::core::stringify!(DeltaMismatch),
            ::core::stringify!(ECDSAInvalidSignature),
            ::core::stringify!(NonExistingRoot),
            ::core::stringify!(ECDSAInvalidSignatureLength),
        ];
        /// The signatures in the same order as `SELECTORS`.
        pub const SIGNATURES: &'static [&'static str] = &[
            <RiscZeroVerifierStopped as alloy_sol_types::SolError>::SIGNATURE,
            <OwnableUnauthorizedAccount as alloy_sol_types::SolError>::SIGNATURE,
            <LogicRefMismatch as alloy_sol_types::SolError>::SIGNATURE,
            <OwnableInvalidOwner as alloy_sol_types::SolError>::SIGNATURE,
            <PreExistingNullifier as alloy_sol_types::SolError>::SIGNATURE,
            <ReentrancyGuardReentrantCall as alloy_sol_types::SolError>::SIGNATURE,
            <Simulated as alloy_sol_types::SolError>::SIGNATURE,
            <RiscZeroVerifierSelectorMismatch as alloy_sol_types::SolError>::SIGNATURE,
            <TagNotFound as alloy_sol_types::SolError>::SIGNATURE,
            <ExpectedPause as alloy_sol_types::SolError>::SIGNATURE,
            <PointNotOnCurve as alloy_sol_types::SolError>::SIGNATURE,
            <ForwarderCallOutputMismatch as alloy_sol_types::SolError>::SIGNATURE,
            <ZeroNotAllowed as alloy_sol_types::SolError>::SIGNATURE,
            <TagCountMismatch as alloy_sol_types::SolError>::SIGNATURE,
            <ECDSAInvalidSignatureS as alloy_sol_types::SolError>::SIGNATURE,
            <EnforcedPause as alloy_sol_types::SolError>::SIGNATURE,
            <PreExistingRoot as alloy_sol_types::SolError>::SIGNATURE,
            <DeltaMismatch as alloy_sol_types::SolError>::SIGNATURE,
            <ECDSAInvalidSignature as alloy_sol_types::SolError>::SIGNATURE,
            <NonExistingRoot as alloy_sol_types::SolError>::SIGNATURE,
            <ECDSAInvalidSignatureLength as alloy_sol_types::SolError>::SIGNATURE,
        ];
        /// Returns the signature for the given selector, if known.
        #[inline]
        pub fn signature_by_selector(
            selector: [u8; 4usize],
        ) -> ::core::option::Option<&'static str> {
            match Self::SELECTORS.binary_search(&selector) {
                ::core::result::Result::Ok(idx) => {
                    ::core::option::Option::Some(Self::SIGNATURES[idx])
                }
                ::core::result::Result::Err(_) => ::core::option::Option::None,
            }
        }
        /// Returns the enum variant name for the given selector, if known.
        #[inline]
        pub fn name_by_selector(
            selector: [u8; 4usize],
        ) -> ::core::option::Option<&'static str> {
            let sig = Self::signature_by_selector(selector)?;
            sig.split_once('(').map(|(name, _)| name)
        }
    }
    #[automatically_derived]
    impl alloy_sol_types::SolInterface for ProtocolAdapterErrors {
        const NAME: &'static str = "ProtocolAdapterErrors";
        const MIN_DATA_LENGTH: usize = 0usize;
        const COUNT: usize = 21usize;
        #[inline]
        fn selector(&self) -> [u8; 4] {
            match self {
                Self::DeltaMismatch(_) => {
                    <DeltaMismatch as alloy_sol_types::SolError>::SELECTOR
                }
                Self::ECDSAInvalidSignature(_) => {
                    <ECDSAInvalidSignature as alloy_sol_types::SolError>::SELECTOR
                }
                Self::ECDSAInvalidSignatureLength(_) => {
                    <ECDSAInvalidSignatureLength as alloy_sol_types::SolError>::SELECTOR
                }
                Self::ECDSAInvalidSignatureS(_) => {
                    <ECDSAInvalidSignatureS as alloy_sol_types::SolError>::SELECTOR
                }
                Self::EnforcedPause(_) => {
                    <EnforcedPause as alloy_sol_types::SolError>::SELECTOR
                }
                Self::ExpectedPause(_) => {
                    <ExpectedPause as alloy_sol_types::SolError>::SELECTOR
                }
                Self::ForwarderCallOutputMismatch(_) => {
                    <ForwarderCallOutputMismatch as alloy_sol_types::SolError>::SELECTOR
                }
                Self::LogicRefMismatch(_) => {
                    <LogicRefMismatch as alloy_sol_types::SolError>::SELECTOR
                }
                Self::NonExistingRoot(_) => {
                    <NonExistingRoot as alloy_sol_types::SolError>::SELECTOR
                }
                Self::OwnableInvalidOwner(_) => {
                    <OwnableInvalidOwner as alloy_sol_types::SolError>::SELECTOR
                }
                Self::OwnableUnauthorizedAccount(_) => {
                    <OwnableUnauthorizedAccount as alloy_sol_types::SolError>::SELECTOR
                }
                Self::PointNotOnCurve(_) => {
                    <PointNotOnCurve as alloy_sol_types::SolError>::SELECTOR
                }
                Self::PreExistingNullifier(_) => {
                    <PreExistingNullifier as alloy_sol_types::SolError>::SELECTOR
                }
                Self::PreExistingRoot(_) => {
                    <PreExistingRoot as alloy_sol_types::SolError>::SELECTOR
                }
                Self::ReentrancyGuardReentrantCall(_) => {
                    <ReentrancyGuardReentrantCall as alloy_sol_types::SolError>::SELECTOR
                }
                Self::RiscZeroVerifierSelectorMismatch(_) => {
                    <RiscZeroVerifierSelectorMismatch as alloy_sol_types::SolError>::SELECTOR
                }
                Self::RiscZeroVerifierStopped(_) => {
                    <RiscZeroVerifierStopped as alloy_sol_types::SolError>::SELECTOR
                }
                Self::Simulated(_) => <Simulated as alloy_sol_types::SolError>::SELECTOR,
                Self::TagCountMismatch(_) => {
                    <TagCountMismatch as alloy_sol_types::SolError>::SELECTOR
                }
                Self::TagNotFound(_) => {
                    <TagNotFound as alloy_sol_types::SolError>::SELECTOR
                }
                Self::ZeroNotAllowed(_) => {
                    <ZeroNotAllowed as alloy_sol_types::SolError>::SELECTOR
                }
            }
        }
        #[inline]
        fn selector_at(i: usize) -> ::core::option::Option<[u8; 4]> {
            Self::SELECTORS.get(i).copied()
        }
        #[inline]
        fn valid_selector(selector: [u8; 4]) -> bool {
            Self::SELECTORS.binary_search(&selector).is_ok()
        }
        #[inline]
        #[allow(non_snake_case)]
        fn abi_decode_raw(
            selector: [u8; 4],
            data: &[u8],
        ) -> alloy_sol_types::Result<Self> {
            static DECODE_SHIMS: &[fn(
                &[u8],
            ) -> alloy_sol_types::Result<ProtocolAdapterErrors>] = &[
                {
                    fn RiscZeroVerifierStopped(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <RiscZeroVerifierStopped as alloy_sol_types::SolError>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterErrors::RiscZeroVerifierStopped)
                    }
                    RiscZeroVerifierStopped
                },
                {
                    fn OwnableUnauthorizedAccount(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <OwnableUnauthorizedAccount as alloy_sol_types::SolError>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterErrors::OwnableUnauthorizedAccount)
                    }
                    OwnableUnauthorizedAccount
                },
                {
                    fn LogicRefMismatch(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <LogicRefMismatch as alloy_sol_types::SolError>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterErrors::LogicRefMismatch)
                    }
                    LogicRefMismatch
                },
                {
                    fn OwnableInvalidOwner(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <OwnableInvalidOwner as alloy_sol_types::SolError>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterErrors::OwnableInvalidOwner)
                    }
                    OwnableInvalidOwner
                },
                {
                    fn PreExistingNullifier(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <PreExistingNullifier as alloy_sol_types::SolError>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterErrors::PreExistingNullifier)
                    }
                    PreExistingNullifier
                },
                {
                    fn ReentrancyGuardReentrantCall(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <ReentrancyGuardReentrantCall as alloy_sol_types::SolError>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterErrors::ReentrancyGuardReentrantCall)
                    }
                    ReentrancyGuardReentrantCall
                },
                {
                    fn Simulated(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <Simulated as alloy_sol_types::SolError>::abi_decode_raw(data)
                            .map(ProtocolAdapterErrors::Simulated)
                    }
                    Simulated
                },
                {
                    fn RiscZeroVerifierSelectorMismatch(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <RiscZeroVerifierSelectorMismatch as alloy_sol_types::SolError>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterErrors::RiscZeroVerifierSelectorMismatch)
                    }
                    RiscZeroVerifierSelectorMismatch
                },
                {
                    fn TagNotFound(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <TagNotFound as alloy_sol_types::SolError>::abi_decode_raw(data)
                            .map(ProtocolAdapterErrors::TagNotFound)
                    }
                    TagNotFound
                },
                {
                    fn ExpectedPause(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <ExpectedPause as alloy_sol_types::SolError>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterErrors::ExpectedPause)
                    }
                    ExpectedPause
                },
                {
                    fn PointNotOnCurve(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <PointNotOnCurve as alloy_sol_types::SolError>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterErrors::PointNotOnCurve)
                    }
                    PointNotOnCurve
                },
                {
                    fn ForwarderCallOutputMismatch(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <ForwarderCallOutputMismatch as alloy_sol_types::SolError>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterErrors::ForwarderCallOutputMismatch)
                    }
                    ForwarderCallOutputMismatch
                },
                {
                    fn ZeroNotAllowed(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <ZeroNotAllowed as alloy_sol_types::SolError>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterErrors::ZeroNotAllowed)
                    }
                    ZeroNotAllowed
                },
                {
                    fn TagCountMismatch(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <TagCountMismatch as alloy_sol_types::SolError>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterErrors::TagCountMismatch)
                    }
                    TagCountMismatch
                },
                {
                    fn ECDSAInvalidSignatureS(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <ECDSAInvalidSignatureS as alloy_sol_types::SolError>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterErrors::ECDSAInvalidSignatureS)
                    }
                    ECDSAInvalidSignatureS
                },
                {
                    fn EnforcedPause(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <EnforcedPause as alloy_sol_types::SolError>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterErrors::EnforcedPause)
                    }
                    EnforcedPause
                },
                {
                    fn PreExistingRoot(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <PreExistingRoot as alloy_sol_types::SolError>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterErrors::PreExistingRoot)
                    }
                    PreExistingRoot
                },
                {
                    fn DeltaMismatch(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <DeltaMismatch as alloy_sol_types::SolError>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterErrors::DeltaMismatch)
                    }
                    DeltaMismatch
                },
                {
                    fn ECDSAInvalidSignature(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <ECDSAInvalidSignature as alloy_sol_types::SolError>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterErrors::ECDSAInvalidSignature)
                    }
                    ECDSAInvalidSignature
                },
                {
                    fn NonExistingRoot(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <NonExistingRoot as alloy_sol_types::SolError>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterErrors::NonExistingRoot)
                    }
                    NonExistingRoot
                },
                {
                    fn ECDSAInvalidSignatureLength(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <ECDSAInvalidSignatureLength as alloy_sol_types::SolError>::abi_decode_raw(
                                data,
                            )
                            .map(ProtocolAdapterErrors::ECDSAInvalidSignatureLength)
                    }
                    ECDSAInvalidSignatureLength
                },
            ];
            let Ok(idx) = Self::SELECTORS.binary_search(&selector) else {
                return Err(
                    alloy_sol_types::Error::unknown_selector(
                        <Self as alloy_sol_types::SolInterface>::NAME,
                        selector,
                    ),
                );
            };
            DECODE_SHIMS[idx](data)
        }
        #[inline]
        #[allow(non_snake_case)]
        fn abi_decode_raw_validate(
            selector: [u8; 4],
            data: &[u8],
        ) -> alloy_sol_types::Result<Self> {
            static DECODE_VALIDATE_SHIMS: &[fn(
                &[u8],
            ) -> alloy_sol_types::Result<ProtocolAdapterErrors>] = &[
                {
                    fn RiscZeroVerifierStopped(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <RiscZeroVerifierStopped as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::RiscZeroVerifierStopped)
                    }
                    RiscZeroVerifierStopped
                },
                {
                    fn OwnableUnauthorizedAccount(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <OwnableUnauthorizedAccount as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::OwnableUnauthorizedAccount)
                    }
                    OwnableUnauthorizedAccount
                },
                {
                    fn LogicRefMismatch(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <LogicRefMismatch as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::LogicRefMismatch)
                    }
                    LogicRefMismatch
                },
                {
                    fn OwnableInvalidOwner(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <OwnableInvalidOwner as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::OwnableInvalidOwner)
                    }
                    OwnableInvalidOwner
                },
                {
                    fn PreExistingNullifier(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <PreExistingNullifier as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::PreExistingNullifier)
                    }
                    PreExistingNullifier
                },
                {
                    fn ReentrancyGuardReentrantCall(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <ReentrancyGuardReentrantCall as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::ReentrancyGuardReentrantCall)
                    }
                    ReentrancyGuardReentrantCall
                },
                {
                    fn Simulated(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <Simulated as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::Simulated)
                    }
                    Simulated
                },
                {
                    fn RiscZeroVerifierSelectorMismatch(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <RiscZeroVerifierSelectorMismatch as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::RiscZeroVerifierSelectorMismatch)
                    }
                    RiscZeroVerifierSelectorMismatch
                },
                {
                    fn TagNotFound(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <TagNotFound as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::TagNotFound)
                    }
                    TagNotFound
                },
                {
                    fn ExpectedPause(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <ExpectedPause as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::ExpectedPause)
                    }
                    ExpectedPause
                },
                {
                    fn PointNotOnCurve(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <PointNotOnCurve as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::PointNotOnCurve)
                    }
                    PointNotOnCurve
                },
                {
                    fn ForwarderCallOutputMismatch(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <ForwarderCallOutputMismatch as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::ForwarderCallOutputMismatch)
                    }
                    ForwarderCallOutputMismatch
                },
                {
                    fn ZeroNotAllowed(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <ZeroNotAllowed as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::ZeroNotAllowed)
                    }
                    ZeroNotAllowed
                },
                {
                    fn TagCountMismatch(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <TagCountMismatch as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::TagCountMismatch)
                    }
                    TagCountMismatch
                },
                {
                    fn ECDSAInvalidSignatureS(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <ECDSAInvalidSignatureS as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::ECDSAInvalidSignatureS)
                    }
                    ECDSAInvalidSignatureS
                },
                {
                    fn EnforcedPause(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <EnforcedPause as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::EnforcedPause)
                    }
                    EnforcedPause
                },
                {
                    fn PreExistingRoot(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <PreExistingRoot as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::PreExistingRoot)
                    }
                    PreExistingRoot
                },
                {
                    fn DeltaMismatch(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <DeltaMismatch as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::DeltaMismatch)
                    }
                    DeltaMismatch
                },
                {
                    fn ECDSAInvalidSignature(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <ECDSAInvalidSignature as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::ECDSAInvalidSignature)
                    }
                    ECDSAInvalidSignature
                },
                {
                    fn NonExistingRoot(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <NonExistingRoot as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::NonExistingRoot)
                    }
                    NonExistingRoot
                },
                {
                    fn ECDSAInvalidSignatureLength(
                        data: &[u8],
                    ) -> alloy_sol_types::Result<ProtocolAdapterErrors> {
                        <ECDSAInvalidSignatureLength as alloy_sol_types::SolError>::abi_decode_raw_validate(
                                data,
                            )
                            .map(ProtocolAdapterErrors::ECDSAInvalidSignatureLength)
                    }
                    ECDSAInvalidSignatureLength
                },
            ];
            let Ok(idx) = Self::SELECTORS.binary_search(&selector) else {
                return Err(
                    alloy_sol_types::Error::unknown_selector(
                        <Self as alloy_sol_types::SolInterface>::NAME,
                        selector,
                    ),
                );
            };
            DECODE_VALIDATE_SHIMS[idx](data)
        }
        #[inline]
        fn abi_encoded_size(&self) -> usize {
            match self {
                Self::DeltaMismatch(inner) => {
                    <DeltaMismatch as alloy_sol_types::SolError>::abi_encoded_size(inner)
                }
                Self::ECDSAInvalidSignature(inner) => {
                    <ECDSAInvalidSignature as alloy_sol_types::SolError>::abi_encoded_size(
                        inner,
                    )
                }
                Self::ECDSAInvalidSignatureLength(inner) => {
                    <ECDSAInvalidSignatureLength as alloy_sol_types::SolError>::abi_encoded_size(
                        inner,
                    )
                }
                Self::ECDSAInvalidSignatureS(inner) => {
                    <ECDSAInvalidSignatureS as alloy_sol_types::SolError>::abi_encoded_size(
                        inner,
                    )
                }
                Self::EnforcedPause(inner) => {
                    <EnforcedPause as alloy_sol_types::SolError>::abi_encoded_size(inner)
                }
                Self::ExpectedPause(inner) => {
                    <ExpectedPause as alloy_sol_types::SolError>::abi_encoded_size(inner)
                }
                Self::ForwarderCallOutputMismatch(inner) => {
                    <ForwarderCallOutputMismatch as alloy_sol_types::SolError>::abi_encoded_size(
                        inner,
                    )
                }
                Self::LogicRefMismatch(inner) => {
                    <LogicRefMismatch as alloy_sol_types::SolError>::abi_encoded_size(
                        inner,
                    )
                }
                Self::NonExistingRoot(inner) => {
                    <NonExistingRoot as alloy_sol_types::SolError>::abi_encoded_size(
                        inner,
                    )
                }
                Self::OwnableInvalidOwner(inner) => {
                    <OwnableInvalidOwner as alloy_sol_types::SolError>::abi_encoded_size(
                        inner,
                    )
                }
                Self::OwnableUnauthorizedAccount(inner) => {
                    <OwnableUnauthorizedAccount as alloy_sol_types::SolError>::abi_encoded_size(
                        inner,
                    )
                }
                Self::PointNotOnCurve(inner) => {
                    <PointNotOnCurve as alloy_sol_types::SolError>::abi_encoded_size(
                        inner,
                    )
                }
                Self::PreExistingNullifier(inner) => {
                    <PreExistingNullifier as alloy_sol_types::SolError>::abi_encoded_size(
                        inner,
                    )
                }
                Self::PreExistingRoot(inner) => {
                    <PreExistingRoot as alloy_sol_types::SolError>::abi_encoded_size(
                        inner,
                    )
                }
                Self::ReentrancyGuardReentrantCall(inner) => {
                    <ReentrancyGuardReentrantCall as alloy_sol_types::SolError>::abi_encoded_size(
                        inner,
                    )
                }
                Self::RiscZeroVerifierSelectorMismatch(inner) => {
                    <RiscZeroVerifierSelectorMismatch as alloy_sol_types::SolError>::abi_encoded_size(
                        inner,
                    )
                }
                Self::RiscZeroVerifierStopped(inner) => {
                    <RiscZeroVerifierStopped as alloy_sol_types::SolError>::abi_encoded_size(
                        inner,
                    )
                }
                Self::Simulated(inner) => {
                    <Simulated as alloy_sol_types::SolError>::abi_encoded_size(inner)
                }
                Self::TagCountMismatch(inner) => {
                    <TagCountMismatch as alloy_sol_types::SolError>::abi_encoded_size(
                        inner,
                    )
                }
                Self::TagNotFound(inner) => {
                    <TagNotFound as alloy_sol_types::SolError>::abi_encoded_size(inner)
                }
                Self::ZeroNotAllowed(inner) => {
                    <ZeroNotAllowed as alloy_sol_types::SolError>::abi_encoded_size(
                        inner,
                    )
                }
            }
        }
        #[inline]
        fn abi_encode_raw(&self, out: &mut alloy_sol_types::private::Vec<u8>) {
            match self {
                Self::DeltaMismatch(inner) => {
                    <DeltaMismatch as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::ECDSAInvalidSignature(inner) => {
                    <ECDSAInvalidSignature as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::ECDSAInvalidSignatureLength(inner) => {
                    <ECDSAInvalidSignatureLength as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::ECDSAInvalidSignatureS(inner) => {
                    <ECDSAInvalidSignatureS as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::EnforcedPause(inner) => {
                    <EnforcedPause as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::ExpectedPause(inner) => {
                    <ExpectedPause as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::ForwarderCallOutputMismatch(inner) => {
                    <ForwarderCallOutputMismatch as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::LogicRefMismatch(inner) => {
                    <LogicRefMismatch as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::NonExistingRoot(inner) => {
                    <NonExistingRoot as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::OwnableInvalidOwner(inner) => {
                    <OwnableInvalidOwner as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::OwnableUnauthorizedAccount(inner) => {
                    <OwnableUnauthorizedAccount as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::PointNotOnCurve(inner) => {
                    <PointNotOnCurve as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::PreExistingNullifier(inner) => {
                    <PreExistingNullifier as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::PreExistingRoot(inner) => {
                    <PreExistingRoot as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::ReentrancyGuardReentrantCall(inner) => {
                    <ReentrancyGuardReentrantCall as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::RiscZeroVerifierSelectorMismatch(inner) => {
                    <RiscZeroVerifierSelectorMismatch as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::RiscZeroVerifierStopped(inner) => {
                    <RiscZeroVerifierStopped as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::Simulated(inner) => {
                    <Simulated as alloy_sol_types::SolError>::abi_encode_raw(inner, out)
                }
                Self::TagCountMismatch(inner) => {
                    <TagCountMismatch as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::TagNotFound(inner) => {
                    <TagNotFound as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
                Self::ZeroNotAllowed(inner) => {
                    <ZeroNotAllowed as alloy_sol_types::SolError>::abi_encode_raw(
                        inner,
                        out,
                    )
                }
            }
        }
    }
    ///Container for all the [`ProtocolAdapter`](self) events.
    #[derive(Clone)]
    #[derive(serde::Serialize, serde::Deserialize)]
    #[derive(Debug, PartialEq, Eq, Hash)]
    pub enum ProtocolAdapterEvents {
        #[allow(missing_docs)]
        ActionExecuted(ActionExecuted),
        #[allow(missing_docs)]
        ApplicationPayload(ApplicationPayload),
        #[allow(missing_docs)]
        CommitmentTreeRootAdded(CommitmentTreeRootAdded),
        #[allow(missing_docs)]
        DiscoveryPayload(DiscoveryPayload),
        #[allow(missing_docs)]
        ExternalPayload(ExternalPayload),
        #[allow(missing_docs)]
        ForwarderCallExecuted(ForwarderCallExecuted),
        #[allow(missing_docs)]
        OwnershipTransferred(OwnershipTransferred),
        #[allow(missing_docs)]
        Paused(Paused),
        #[allow(missing_docs)]
        ResourcePayload(ResourcePayload),
        #[allow(missing_docs)]
        TransactionExecuted(TransactionExecuted),
        #[allow(missing_docs)]
        Unpaused(Unpaused),
    }
    impl ProtocolAdapterEvents {
        /// All the selectors of this enum.
        ///
        /// Note that the selectors might not be in the same order as the variants.
        /// No guarantees are made about the order of the selectors.
        ///
        /// Prefer using `SolInterface` methods instead.
        pub const SELECTORS: &'static [[u8; 32usize]] = &[
            [
                10u8, 45u8, 197u8, 72u8, 237u8, 149u8, 10u8, 204u8, 180u8, 13u8, 93u8,
                120u8, 84u8, 31u8, 57u8, 84u8, 197u8, 225u8, 130u8, 168u8, 236u8, 241u8,
                158u8, 88u8, 26u8, 79u8, 34u8, 99u8, 246u8, 31u8, 89u8, 210u8,
            ],
            [
                16u8, 221u8, 82u8, 141u8, 178u8, 196u8, 154u8, 221u8, 101u8, 69u8, 103u8,
                155u8, 151u8, 109u8, 249u8, 13u8, 36u8, 192u8, 53u8, 214u8, 167u8, 91u8,
                23u8, 244u8, 27u8, 112u8, 14u8, 140u8, 24u8, 202u8, 83u8, 100u8,
            ],
            [
                28u8, 201u8, 160u8, 117u8, 93u8, 215u8, 52u8, 193u8, 235u8, 254u8, 152u8,
                182u8, 142u8, 206u8, 32u8, 0u8, 55u8, 227u8, 99u8, 235u8, 54u8, 109u8,
                13u8, 238u8, 4u8, 228u8, 32u8, 226u8, 242u8, 60u8, 192u8, 16u8,
            ],
            [
                58u8, 19u8, 77u8, 1u8, 192u8, 120u8, 3u8, 0u8, 60u8, 99u8, 48u8, 23u8,
                23u8, 221u8, 196u8, 97u8, 46u8, 108u8, 71u8, 174u8, 64u8, 142u8, 238u8,
                163u8, 34u8, 44u8, 222u8, 213u8, 50u8, 208u8, 42u8, 230u8,
            ],
            [
                72u8, 36u8, 56u8, 115u8, 180u8, 117u8, 45u8, 220u8, 180u8, 94u8, 13u8,
                123u8, 17u8, 196u8, 194u8, 102u8, 88u8, 62u8, 94u8, 9u8, 154u8, 11u8,
                121u8, 143u8, 221u8, 156u8, 26u8, 247u8, 212u8, 147u8, 36u8, 243u8,
            ],
            [
                93u8, 185u8, 238u8, 10u8, 73u8, 91u8, 242u8, 230u8, 255u8, 156u8, 145u8,
                167u8, 131u8, 76u8, 27u8, 164u8, 253u8, 210u8, 68u8, 165u8, 232u8, 170u8,
                78u8, 83u8, 123u8, 211u8, 138u8, 234u8, 228u8, 176u8, 115u8, 170u8,
            ],
            [
                98u8, 231u8, 140u8, 234u8, 1u8, 190u8, 227u8, 32u8, 205u8, 78u8, 66u8,
                2u8, 112u8, 181u8, 234u8, 116u8, 0u8, 13u8, 17u8, 176u8, 201u8, 247u8,
                71u8, 84u8, 235u8, 219u8, 252u8, 84u8, 75u8, 5u8, 162u8, 88u8,
            ],
            [
                139u8, 224u8, 7u8, 156u8, 83u8, 22u8, 89u8, 20u8, 19u8, 68u8, 205u8,
                31u8, 208u8, 164u8, 242u8, 132u8, 25u8, 73u8, 127u8, 151u8, 34u8, 163u8,
                218u8, 175u8, 227u8, 180u8, 24u8, 111u8, 107u8, 100u8, 87u8, 224u8,
            ],
            [
                156u8, 97u8, 178u8, 144u8, 246u8, 49u8, 9u8, 127u8, 86u8, 39u8, 60u8,
                244u8, 218u8, 244u8, 13u8, 241u8, 255u8, 156u8, 204u8, 51u8, 241u8, 1u8,
                212u8, 100u8, 131u8, 125u8, 161u8, 245u8, 174u8, 24u8, 189u8, 89u8,
            ],
            [
                164u8, 148u8, 218u8, 196u8, 183u8, 24u8, 72u8, 67u8, 88u8, 63u8, 151u8,
                46u8, 6u8, 120u8, 62u8, 44u8, 59u8, 180u8, 127u8, 79u8, 1u8, 55u8, 184u8,
                223u8, 82u8, 168u8, 96u8, 223u8, 7u8, 33u8, 159u8, 140u8,
            ],
            [
                205u8, 219u8, 50u8, 122u8, 219u8, 49u8, 254u8, 84u8, 55u8, 223u8, 42u8,
                140u8, 104u8, 48u8, 27u8, 177u8, 58u8, 107u8, 170u8, 228u8, 50u8, 168u8,
                4u8, 131u8, 140u8, 170u8, 246u8, 130u8, 80u8, 106u8, 173u8, 241u8,
            ],
        ];
        /// The names of the variants in the same order as `SELECTORS`.
        pub const VARIANT_NAMES: &'static [&'static str] = &[
            ::core::stringify!(CommitmentTreeRootAdded),
            ::core::stringify!(TransactionExecuted),
            ::core::stringify!(ActionExecuted),
            ::core::stringify!(ResourcePayload),
            ::core::stringify!(DiscoveryPayload),
            ::core::stringify!(Unpaused),
            ::core::stringify!(Paused),
            ::core::stringify!(OwnershipTransferred),
            ::core::stringify!(ExternalPayload),
            ::core::stringify!(ApplicationPayload),
            ::core::stringify!(ForwarderCallExecuted),
        ];
        /// The signatures in the same order as `SELECTORS`.
        pub const SIGNATURES: &'static [&'static str] = &[
            <CommitmentTreeRootAdded as alloy_sol_types::SolEvent>::SIGNATURE,
            <TransactionExecuted as alloy_sol_types::SolEvent>::SIGNATURE,
            <ActionExecuted as alloy_sol_types::SolEvent>::SIGNATURE,
            <ResourcePayload as alloy_sol_types::SolEvent>::SIGNATURE,
            <DiscoveryPayload as alloy_sol_types::SolEvent>::SIGNATURE,
            <Unpaused as alloy_sol_types::SolEvent>::SIGNATURE,
            <Paused as alloy_sol_types::SolEvent>::SIGNATURE,
            <OwnershipTransferred as alloy_sol_types::SolEvent>::SIGNATURE,
            <ExternalPayload as alloy_sol_types::SolEvent>::SIGNATURE,
            <ApplicationPayload as alloy_sol_types::SolEvent>::SIGNATURE,
            <ForwarderCallExecuted as alloy_sol_types::SolEvent>::SIGNATURE,
        ];
        /// Returns the signature for the given selector, if known.
        #[inline]
        pub fn signature_by_selector(
            selector: [u8; 32usize],
        ) -> ::core::option::Option<&'static str> {
            match Self::SELECTORS.binary_search(&selector) {
                ::core::result::Result::Ok(idx) => {
                    ::core::option::Option::Some(Self::SIGNATURES[idx])
                }
                ::core::result::Result::Err(_) => ::core::option::Option::None,
            }
        }
        /// Returns the enum variant name for the given selector, if known.
        #[inline]
        pub fn name_by_selector(
            selector: [u8; 32usize],
        ) -> ::core::option::Option<&'static str> {
            let sig = Self::signature_by_selector(selector)?;
            sig.split_once('(').map(|(name, _)| name)
        }
    }
    #[automatically_derived]
    impl alloy_sol_types::SolEventInterface for ProtocolAdapterEvents {
        const NAME: &'static str = "ProtocolAdapterEvents";
        const COUNT: usize = 11usize;
        fn decode_raw_log(
            topics: &[alloy_sol_types::Word],
            data: &[u8],
        ) -> alloy_sol_types::Result<Self> {
            match topics.first().copied() {
                Some(<ActionExecuted as alloy_sol_types::SolEvent>::SIGNATURE_HASH) => {
                    <ActionExecuted as alloy_sol_types::SolEvent>::decode_raw_log(
                            topics,
                            data,
                        )
                        .map(Self::ActionExecuted)
                }
                Some(
                    <ApplicationPayload as alloy_sol_types::SolEvent>::SIGNATURE_HASH,
                ) => {
                    <ApplicationPayload as alloy_sol_types::SolEvent>::decode_raw_log(
                            topics,
                            data,
                        )
                        .map(Self::ApplicationPayload)
                }
                Some(
                    <CommitmentTreeRootAdded as alloy_sol_types::SolEvent>::SIGNATURE_HASH,
                ) => {
                    <CommitmentTreeRootAdded as alloy_sol_types::SolEvent>::decode_raw_log(
                            topics,
                            data,
                        )
                        .map(Self::CommitmentTreeRootAdded)
                }
                Some(<DiscoveryPayload as alloy_sol_types::SolEvent>::SIGNATURE_HASH) => {
                    <DiscoveryPayload as alloy_sol_types::SolEvent>::decode_raw_log(
                            topics,
                            data,
                        )
                        .map(Self::DiscoveryPayload)
                }
                Some(<ExternalPayload as alloy_sol_types::SolEvent>::SIGNATURE_HASH) => {
                    <ExternalPayload as alloy_sol_types::SolEvent>::decode_raw_log(
                            topics,
                            data,
                        )
                        .map(Self::ExternalPayload)
                }
                Some(
                    <ForwarderCallExecuted as alloy_sol_types::SolEvent>::SIGNATURE_HASH,
                ) => {
                    <ForwarderCallExecuted as alloy_sol_types::SolEvent>::decode_raw_log(
                            topics,
                            data,
                        )
                        .map(Self::ForwarderCallExecuted)
                }
                Some(
                    <OwnershipTransferred as alloy_sol_types::SolEvent>::SIGNATURE_HASH,
                ) => {
                    <OwnershipTransferred as alloy_sol_types::SolEvent>::decode_raw_log(
                            topics,
                            data,
                        )
                        .map(Self::OwnershipTransferred)
                }
                Some(<Paused as alloy_sol_types::SolEvent>::SIGNATURE_HASH) => {
                    <Paused as alloy_sol_types::SolEvent>::decode_raw_log(topics, data)
                        .map(Self::Paused)
                }
                Some(<ResourcePayload as alloy_sol_types::SolEvent>::SIGNATURE_HASH) => {
                    <ResourcePayload as alloy_sol_types::SolEvent>::decode_raw_log(
                            topics,
                            data,
                        )
                        .map(Self::ResourcePayload)
                }
                Some(
                    <TransactionExecuted as alloy_sol_types::SolEvent>::SIGNATURE_HASH,
                ) => {
                    <TransactionExecuted as alloy_sol_types::SolEvent>::decode_raw_log(
                            topics,
                            data,
                        )
                        .map(Self::TransactionExecuted)
                }
                Some(<Unpaused as alloy_sol_types::SolEvent>::SIGNATURE_HASH) => {
                    <Unpaused as alloy_sol_types::SolEvent>::decode_raw_log(topics, data)
                        .map(Self::Unpaused)
                }
                _ => {
                    alloy_sol_types::private::Err(alloy_sol_types::Error::InvalidLog {
                        name: <Self as alloy_sol_types::SolEventInterface>::NAME,
                        log: alloy_sol_types::private::Box::new(
                            alloy_sol_types::private::LogData::new_unchecked(
                                topics.to_vec(),
                                data.to_vec().into(),
                            ),
                        ),
                    })
                }
            }
        }
    }
    #[automatically_derived]
    impl alloy_sol_types::private::IntoLogData for ProtocolAdapterEvents {
        fn to_log_data(&self) -> alloy_sol_types::private::LogData {
            match self {
                Self::ActionExecuted(inner) => {
                    alloy_sol_types::private::IntoLogData::to_log_data(inner)
                }
                Self::ApplicationPayload(inner) => {
                    alloy_sol_types::private::IntoLogData::to_log_data(inner)
                }
                Self::CommitmentTreeRootAdded(inner) => {
                    alloy_sol_types::private::IntoLogData::to_log_data(inner)
                }
                Self::DiscoveryPayload(inner) => {
                    alloy_sol_types::private::IntoLogData::to_log_data(inner)
                }
                Self::ExternalPayload(inner) => {
                    alloy_sol_types::private::IntoLogData::to_log_data(inner)
                }
                Self::ForwarderCallExecuted(inner) => {
                    alloy_sol_types::private::IntoLogData::to_log_data(inner)
                }
                Self::OwnershipTransferred(inner) => {
                    alloy_sol_types::private::IntoLogData::to_log_data(inner)
                }
                Self::Paused(inner) => {
                    alloy_sol_types::private::IntoLogData::to_log_data(inner)
                }
                Self::ResourcePayload(inner) => {
                    alloy_sol_types::private::IntoLogData::to_log_data(inner)
                }
                Self::TransactionExecuted(inner) => {
                    alloy_sol_types::private::IntoLogData::to_log_data(inner)
                }
                Self::Unpaused(inner) => {
                    alloy_sol_types::private::IntoLogData::to_log_data(inner)
                }
            }
        }
        fn into_log_data(self) -> alloy_sol_types::private::LogData {
            match self {
                Self::ActionExecuted(inner) => {
                    alloy_sol_types::private::IntoLogData::into_log_data(inner)
                }
                Self::ApplicationPayload(inner) => {
                    alloy_sol_types::private::IntoLogData::into_log_data(inner)
                }
                Self::CommitmentTreeRootAdded(inner) => {
                    alloy_sol_types::private::IntoLogData::into_log_data(inner)
                }
                Self::DiscoveryPayload(inner) => {
                    alloy_sol_types::private::IntoLogData::into_log_data(inner)
                }
                Self::ExternalPayload(inner) => {
                    alloy_sol_types::private::IntoLogData::into_log_data(inner)
                }
                Self::ForwarderCallExecuted(inner) => {
                    alloy_sol_types::private::IntoLogData::into_log_data(inner)
                }
                Self::OwnershipTransferred(inner) => {
                    alloy_sol_types::private::IntoLogData::into_log_data(inner)
                }
                Self::Paused(inner) => {
                    alloy_sol_types::private::IntoLogData::into_log_data(inner)
                }
                Self::ResourcePayload(inner) => {
                    alloy_sol_types::private::IntoLogData::into_log_data(inner)
                }
                Self::TransactionExecuted(inner) => {
                    alloy_sol_types::private::IntoLogData::into_log_data(inner)
                }
                Self::Unpaused(inner) => {
                    alloy_sol_types::private::IntoLogData::into_log_data(inner)
                }
            }
        }
    }
    use alloy::contract as alloy_contract;
    /**Creates a new wrapper around an on-chain [`ProtocolAdapter`](self) contract instance.

See the [wrapper's documentation](`ProtocolAdapterInstance`) for more details.*/
    #[inline]
    pub const fn new<
        P: alloy_contract::private::Provider<N>,
        N: alloy_contract::private::Network,
    >(
        address: alloy_sol_types::private::Address,
        __provider: P,
    ) -> ProtocolAdapterInstance<P, N> {
        ProtocolAdapterInstance::<P, N>::new(address, __provider)
    }
    /**Deploys this contract using the given `provider` and constructor arguments, if any.

Returns a new instance of the contract, if the deployment was successful.

For more fine-grained control over the deployment process, use [`deploy_builder`] instead.*/
    #[inline]
    pub fn deploy<
        P: alloy_contract::private::Provider<N>,
        N: alloy_contract::private::Network,
    >(
        __provider: P,
        riscZeroVerifierRouter: alloy::sol_types::private::Address,
        riscZeroVerifierSelector: alloy::sol_types::private::FixedBytes<4>,
        emergencyStopCaller: alloy::sol_types::private::Address,
    ) -> impl ::core::future::Future<
        Output = alloy_contract::Result<ProtocolAdapterInstance<P, N>>,
    > {
        ProtocolAdapterInstance::<
            P,
            N,
        >::deploy(
            __provider,
            riscZeroVerifierRouter,
            riscZeroVerifierSelector,
            emergencyStopCaller,
        )
    }
    /**Creates a `RawCallBuilder` for deploying this contract using the given `provider`
and constructor arguments, if any.

This is a simple wrapper around creating a `RawCallBuilder` with the data set to
the bytecode concatenated with the constructor's ABI-encoded arguments.*/
    #[inline]
    pub fn deploy_builder<
        P: alloy_contract::private::Provider<N>,
        N: alloy_contract::private::Network,
    >(
        __provider: P,
        riscZeroVerifierRouter: alloy::sol_types::private::Address,
        riscZeroVerifierSelector: alloy::sol_types::private::FixedBytes<4>,
        emergencyStopCaller: alloy::sol_types::private::Address,
    ) -> alloy_contract::RawCallBuilder<P, N> {
        ProtocolAdapterInstance::<
            P,
            N,
        >::deploy_builder(
            __provider,
            riscZeroVerifierRouter,
            riscZeroVerifierSelector,
            emergencyStopCaller,
        )
    }
    /**A [`ProtocolAdapter`](self) instance.

Contains type-safe methods for interacting with an on-chain instance of the
[`ProtocolAdapter`](self) contract located at a given `address`, using a given
provider `P`.

If the contract bytecode is available (see the [`sol!`](alloy_sol_types::sol!)
documentation on how to provide it), the `deploy` and `deploy_builder` methods can
be used to deploy a new instance of the contract.

See the [module-level documentation](self) for all the available methods.*/
    #[derive(Clone)]
    pub struct ProtocolAdapterInstance<P, N = alloy_contract::private::Ethereum> {
        address: alloy_sol_types::private::Address,
        provider: P,
        _network: ::core::marker::PhantomData<N>,
    }
    #[automatically_derived]
    impl<P, N> ::core::fmt::Debug for ProtocolAdapterInstance<P, N> {
        #[inline]
        fn fmt(&self, f: &mut ::core::fmt::Formatter<'_>) -> ::core::fmt::Result {
            f.debug_tuple("ProtocolAdapterInstance").field(&self.address).finish()
        }
    }
    /// Instantiation and getters/setters.
    impl<
        P: alloy_contract::private::Provider<N>,
        N: alloy_contract::private::Network,
    > ProtocolAdapterInstance<P, N> {
        /**Creates a new wrapper around an on-chain [`ProtocolAdapter`](self) contract instance.

See the [wrapper's documentation](`ProtocolAdapterInstance`) for more details.*/
        #[inline]
        pub const fn new(
            address: alloy_sol_types::private::Address,
            __provider: P,
        ) -> Self {
            Self {
                address,
                provider: __provider,
                _network: ::core::marker::PhantomData,
            }
        }
        /**Deploys this contract using the given `provider` and constructor arguments, if any.

Returns a new instance of the contract, if the deployment was successful.

For more fine-grained control over the deployment process, use [`deploy_builder`] instead.*/
        #[inline]
        pub async fn deploy(
            __provider: P,
            riscZeroVerifierRouter: alloy::sol_types::private::Address,
            riscZeroVerifierSelector: alloy::sol_types::private::FixedBytes<4>,
            emergencyStopCaller: alloy::sol_types::private::Address,
        ) -> alloy_contract::Result<ProtocolAdapterInstance<P, N>> {
            let call_builder = Self::deploy_builder(
                __provider,
                riscZeroVerifierRouter,
                riscZeroVerifierSelector,
                emergencyStopCaller,
            );
            let contract_address = call_builder.deploy().await?;
            Ok(Self::new(contract_address, call_builder.provider))
        }
        /**Creates a `RawCallBuilder` for deploying this contract using the given `provider`
and constructor arguments, if any.

This is a simple wrapper around creating a `RawCallBuilder` with the data set to
the bytecode concatenated with the constructor's ABI-encoded arguments.*/
        #[inline]
        pub fn deploy_builder(
            __provider: P,
            riscZeroVerifierRouter: alloy::sol_types::private::Address,
            riscZeroVerifierSelector: alloy::sol_types::private::FixedBytes<4>,
            emergencyStopCaller: alloy::sol_types::private::Address,
        ) -> alloy_contract::RawCallBuilder<P, N> {
            alloy_contract::RawCallBuilder::new_raw_deploy(
                __provider,
                [
                    &BYTECODE[..],
                    &alloy_sol_types::SolConstructor::abi_encode(
                        &constructorCall {
                            riscZeroVerifierRouter,
                            riscZeroVerifierSelector,
                            emergencyStopCaller,
                        },
                    )[..],
                ]
                    .concat()
                    .into(),
            )
        }
        /// Returns a reference to the address.
        #[inline]
        pub const fn address(&self) -> &alloy_sol_types::private::Address {
            &self.address
        }
        /// Sets the address.
        #[inline]
        pub fn set_address(&mut self, address: alloy_sol_types::private::Address) {
            self.address = address;
        }
        /// Sets the address and returns `self`.
        pub fn at(mut self, address: alloy_sol_types::private::Address) -> Self {
            self.set_address(address);
            self
        }
        /// Returns a reference to the provider.
        #[inline]
        pub const fn provider(&self) -> &P {
            &self.provider
        }
    }
    impl<P: ::core::clone::Clone, N> ProtocolAdapterInstance<&P, N> {
        /// Clones the provider and returns a new instance with the cloned provider.
        #[inline]
        pub fn with_cloned_provider(self) -> ProtocolAdapterInstance<P, N> {
            ProtocolAdapterInstance {
                address: self.address,
                provider: ::core::clone::Clone::clone(&self.provider),
                _network: ::core::marker::PhantomData,
            }
        }
    }
    /// Function calls.
    impl<
        P: alloy_contract::private::Provider<N>,
        N: alloy_contract::private::Network,
    > ProtocolAdapterInstance<P, N> {
        /// Creates a new call builder using this contract instance's provider and address.
        ///
        /// Note that the call can be any function call, not just those defined in this
        /// contract. Prefer using the other methods for building type-safe contract calls.
        pub fn call_builder<C: alloy_sol_types::SolCall>(
            &self,
            call: &C,
        ) -> alloy_contract::SolCallBuilder<&P, C, N> {
            alloy_contract::SolCallBuilder::new_sol(&self.provider, &self.address, call)
        }
        ///Creates a new call builder for the [`commitmentCount`] function.
        pub fn commitmentCount(
            &self,
        ) -> alloy_contract::SolCallBuilder<&P, commitmentCountCall, N> {
            self.call_builder(&commitmentCountCall)
        }
        ///Creates a new call builder for the [`commitmentTreeCapacity`] function.
        pub fn commitmentTreeCapacity(
            &self,
        ) -> alloy_contract::SolCallBuilder<&P, commitmentTreeCapacityCall, N> {
            self.call_builder(&commitmentTreeCapacityCall)
        }
        ///Creates a new call builder for the [`commitmentTreeDepth`] function.
        pub fn commitmentTreeDepth(
            &self,
        ) -> alloy_contract::SolCallBuilder<&P, commitmentTreeDepthCall, N> {
            self.call_builder(&commitmentTreeDepthCall)
        }
        ///Creates a new call builder for the [`commitmentTreeRootAtIndex`] function.
        pub fn commitmentTreeRootAtIndex(
            &self,
            index: alloy::sol_types::private::primitives::aliases::U256,
        ) -> alloy_contract::SolCallBuilder<&P, commitmentTreeRootAtIndexCall, N> {
            self.call_builder(
                &commitmentTreeRootAtIndexCall {
                    index,
                },
            )
        }
        ///Creates a new call builder for the [`commitmentTreeRootCount`] function.
        pub fn commitmentTreeRootCount(
            &self,
        ) -> alloy_contract::SolCallBuilder<&P, commitmentTreeRootCountCall, N> {
            self.call_builder(&commitmentTreeRootCountCall)
        }
        ///Creates a new call builder for the [`emergencyStop`] function.
        pub fn emergencyStop(
            &self,
        ) -> alloy_contract::SolCallBuilder<&P, emergencyStopCall, N> {
            self.call_builder(&emergencyStopCall)
        }
        ///Creates a new call builder for the [`execute`] function.
        pub fn execute(
            &self,
            transaction: <Transaction as alloy::sol_types::SolType>::RustType,
        ) -> alloy_contract::SolCallBuilder<&P, executeCall, N> {
            self.call_builder(&executeCall { transaction })
        }
        ///Creates a new call builder for the [`getRiscZeroVerifierRouter`] function.
        pub fn getRiscZeroVerifierRouter(
            &self,
        ) -> alloy_contract::SolCallBuilder<&P, getRiscZeroVerifierRouterCall, N> {
            self.call_builder(&getRiscZeroVerifierRouterCall)
        }
        ///Creates a new call builder for the [`getRiscZeroVerifierSelector`] function.
        pub fn getRiscZeroVerifierSelector(
            &self,
        ) -> alloy_contract::SolCallBuilder<&P, getRiscZeroVerifierSelectorCall, N> {
            self.call_builder(&getRiscZeroVerifierSelectorCall)
        }
        ///Creates a new call builder for the [`getVersion`] function.
        pub fn getVersion(
            &self,
        ) -> alloy_contract::SolCallBuilder<&P, getVersionCall, N> {
            self.call_builder(&getVersionCall)
        }
        ///Creates a new call builder for the [`isCommitmentTreeRootContained`] function.
        pub fn isCommitmentTreeRootContained(
            &self,
            root: alloy::sol_types::private::FixedBytes<32>,
        ) -> alloy_contract::SolCallBuilder<&P, isCommitmentTreeRootContainedCall, N> {
            self.call_builder(
                &isCommitmentTreeRootContainedCall {
                    root,
                },
            )
        }
        ///Creates a new call builder for the [`isEmergencyStopped`] function.
        pub fn isEmergencyStopped(
            &self,
        ) -> alloy_contract::SolCallBuilder<&P, isEmergencyStoppedCall, N> {
            self.call_builder(&isEmergencyStoppedCall)
        }
        ///Creates a new call builder for the [`isNullifierContained`] function.
        pub fn isNullifierContained(
            &self,
            nullifier: alloy::sol_types::private::FixedBytes<32>,
        ) -> alloy_contract::SolCallBuilder<&P, isNullifierContainedCall, N> {
            self.call_builder(
                &isNullifierContainedCall {
                    nullifier,
                },
            )
        }
        ///Creates a new call builder for the [`latestCommitmentTreeRoot`] function.
        pub fn latestCommitmentTreeRoot(
            &self,
        ) -> alloy_contract::SolCallBuilder<&P, latestCommitmentTreeRootCall, N> {
            self.call_builder(&latestCommitmentTreeRootCall)
        }
        ///Creates a new call builder for the [`nullifierAtIndex`] function.
        pub fn nullifierAtIndex(
            &self,
            index: alloy::sol_types::private::primitives::aliases::U256,
        ) -> alloy_contract::SolCallBuilder<&P, nullifierAtIndexCall, N> {
            self.call_builder(&nullifierAtIndexCall { index })
        }
        ///Creates a new call builder for the [`nullifierCount`] function.
        pub fn nullifierCount(
            &self,
        ) -> alloy_contract::SolCallBuilder<&P, nullifierCountCall, N> {
            self.call_builder(&nullifierCountCall)
        }
        ///Creates a new call builder for the [`owner`] function.
        pub fn owner(&self) -> alloy_contract::SolCallBuilder<&P, ownerCall, N> {
            self.call_builder(&ownerCall)
        }
        ///Creates a new call builder for the [`paused`] function.
        pub fn paused(&self) -> alloy_contract::SolCallBuilder<&P, pausedCall, N> {
            self.call_builder(&pausedCall)
        }
        ///Creates a new call builder for the [`renounceOwnership`] function.
        pub fn renounceOwnership(
            &self,
        ) -> alloy_contract::SolCallBuilder<&P, renounceOwnershipCall, N> {
            self.call_builder(&renounceOwnershipCall)
        }
        ///Creates a new call builder for the [`simulateExecute`] function.
        pub fn simulateExecute(
            &self,
            transaction: <Transaction as alloy::sol_types::SolType>::RustType,
            skipRiscZeroProofVerification: bool,
        ) -> alloy_contract::SolCallBuilder<&P, simulateExecuteCall, N> {
            self.call_builder(
                &simulateExecuteCall {
                    transaction,
                    skipRiscZeroProofVerification,
                },
            )
        }
        ///Creates a new call builder for the [`transferOwnership`] function.
        pub fn transferOwnership(
            &self,
            newOwner: alloy::sol_types::private::Address,
        ) -> alloy_contract::SolCallBuilder<&P, transferOwnershipCall, N> {
            self.call_builder(&transferOwnershipCall { newOwner })
        }
    }
    /// Event filters.
    impl<
        P: alloy_contract::private::Provider<N>,
        N: alloy_contract::private::Network,
    > ProtocolAdapterInstance<P, N> {
        /// Creates a new event filter using this contract instance's provider and address.
        ///
        /// Note that the type can be any event, not just those defined in this contract.
        /// Prefer using the other methods for building type-safe event filters.
        pub fn event_filter<E: alloy_sol_types::SolEvent>(
            &self,
        ) -> alloy_contract::Event<&P, E, N> {
            alloy_contract::Event::new_sol(&self.provider, &self.address)
        }
        ///Creates a new event filter for the [`ActionExecuted`] event.
        pub fn ActionExecuted_filter(
            &self,
        ) -> alloy_contract::Event<&P, ActionExecuted, N> {
            self.event_filter::<ActionExecuted>()
        }
        ///Creates a new event filter for the [`ApplicationPayload`] event.
        pub fn ApplicationPayload_filter(
            &self,
        ) -> alloy_contract::Event<&P, ApplicationPayload, N> {
            self.event_filter::<ApplicationPayload>()
        }
        ///Creates a new event filter for the [`CommitmentTreeRootAdded`] event.
        pub fn CommitmentTreeRootAdded_filter(
            &self,
        ) -> alloy_contract::Event<&P, CommitmentTreeRootAdded, N> {
            self.event_filter::<CommitmentTreeRootAdded>()
        }
        ///Creates a new event filter for the [`DiscoveryPayload`] event.
        pub fn DiscoveryPayload_filter(
            &self,
        ) -> alloy_contract::Event<&P, DiscoveryPayload, N> {
            self.event_filter::<DiscoveryPayload>()
        }
        ///Creates a new event filter for the [`ExternalPayload`] event.
        pub fn ExternalPayload_filter(
            &self,
        ) -> alloy_contract::Event<&P, ExternalPayload, N> {
            self.event_filter::<ExternalPayload>()
        }
        ///Creates a new event filter for the [`ForwarderCallExecuted`] event.
        pub fn ForwarderCallExecuted_filter(
            &self,
        ) -> alloy_contract::Event<&P, ForwarderCallExecuted, N> {
            self.event_filter::<ForwarderCallExecuted>()
        }
        ///Creates a new event filter for the [`OwnershipTransferred`] event.
        pub fn OwnershipTransferred_filter(
            &self,
        ) -> alloy_contract::Event<&P, OwnershipTransferred, N> {
            self.event_filter::<OwnershipTransferred>()
        }
        ///Creates a new event filter for the [`Paused`] event.
        pub fn Paused_filter(&self) -> alloy_contract::Event<&P, Paused, N> {
            self.event_filter::<Paused>()
        }
        ///Creates a new event filter for the [`ResourcePayload`] event.
        pub fn ResourcePayload_filter(
            &self,
        ) -> alloy_contract::Event<&P, ResourcePayload, N> {
            self.event_filter::<ResourcePayload>()
        }
        ///Creates a new event filter for the [`TransactionExecuted`] event.
        pub fn TransactionExecuted_filter(
            &self,
        ) -> alloy_contract::Event<&P, TransactionExecuted, N> {
            self.event_filter::<TransactionExecuted>()
        }
        ///Creates a new event filter for the [`Unpaused`] event.
        pub fn Unpaused_filter(&self) -> alloy_contract::Event<&P, Unpaused, N> {
            self.event_filter::<Unpaused>()
        }
    }
}

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
    ///0x60c0806040523461023857606081614934803803809161001f8285610308565b8339810103126102385780516001600160a01b038116918282036102385760208101516001600160e01b031981169182820361023857604001516001600160a01b038116908190036102385780156102f5575f80546001600160a01b03198116831782556001600160a01b0316907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e09080a36101006003555f5f5160206149145f395f51905f525b61010082106102a15750505f6001556100de61033f565b507f0a2dc548ed950accb40d5d78541f3954c5e182a8ecf19e581a4f2263f61f59d260206040515f5160206149145f395f51905f528152a183156102925760209260805260a052602460405180948193633cadf44960e01b835260048301525afa908115610244575f9161024f575b50604051635c975abb60e01b815290602090829060049082906001600160a01b03165afa908115610244575f91610205575b5060ff5f5460a01c169081156101fd575b506101ee576040516144fb90816103f982396080518181816101c50152818161091101528181610ed50152818161198e01528181611d50015281816121b50152818161302f015261383f015260a05181818161018301526112ad0152f35b630b1d38a360e01b5f5260045ffd5b90505f610190565b90506020813d60201161023c575b8161022060209383610308565b8101031261023857518015158103610238575f61017f565b5f80fd5b3d9150610213565b6040513d5f823e3d90fd5b90506020813d60201161028a575b8161026a60209383610308565b8101031261023857516001600160a01b038116810361023857602061014d565b3d915061025d565b6367a5a71760e11b5f5260045ffd5b5f6020916003825280848484200155604051838101918083526040820152604081526102ce606082610308565b604051918291518091835e8101838152039060025afa156102445760015f519101906100c7565b631e4fbdf760e01b5f525f60045260245ffd5b601f909101601f19168101906001600160401b0382119082101761032b57604052565b634e487b7160e01b5f52604160045260245ffd5b5f5160206149145f395f51905f525f5260056020525f5160206148f45f395f51905f52546103f4576004546801000000000000000081101561032b5760018101806004558110156103e0575f5160206149145f395f51905f527f8a35acfbc15ff81a39ae7d344fd709f28e8600b4aa8c65c6b64bfe7fe36bd19b9091018190556004545f9190915260056020525f5160206148f45f395f51905f5255600190565b634e487b7160e01b5f52603260045260245ffd5b5f9056fe6080806040526004361015610012575f80fd5b5f3560e01c9081630d8e6e2c146122315750806331ee62421461221357806340f34d42146121f657806359ba9258146121d95780635b666b1e146121895780635c975abb1461216557806363a599a4146120d4578063715018a61461205857806382d32ad81461144d5780638da5cb5b1461141b5780639ad91d4c1461139e578063a06056f71461137e578063bdeb442d14611346578063c1b0bed71461131a578063c44956d1146112fd578063c879dbe4146112d1578063e33845cf14611275578063ed3cf91f146103d9578063f2fde38b14610308578063fddd48371461012a5763fe18ab9114610103575f80fd5b34610126575f600319360112610126576020600160ff600254161b604051908152f35b5f80fd5b34610126575f600319360112610126576040517f3cadf4490000000000000000000000000000000000000000000000000000000081527fffffffff000000000000000000000000000000000000000000000000000000007f000000000000000000000000000000000000000000000000000000000000000016600482015260208160248173ffffffffffffffffffffffffffffffffffffffff7f0000000000000000000000000000000000000000000000000000000000000000165afa9081156102ad575f916102b8575b50602073ffffffffffffffffffffffffffffffffffffffff916004604051809481937f5c975abb000000000000000000000000000000000000000000000000000000008352165afa80156102ad575f90610271575b6020915060ff5f5460a01c16908115610269575b506040519015158152f35b90508261025e565b506020813d6020116102a5575b8161028b60209383612314565b81010312610126575180151581036101265760209061024a565b3d915061027e565b6040513d5f823e3d90fd5b90506020813d602011610300575b816102d360209383612314565b81010312610126575173ffffffffffffffffffffffffffffffffffffffff811681036101265760206101f5565b3d91506102c6565b346101265760206003193601126101265760043573ffffffffffffffffffffffffffffffffffffffff811680910361012657610342612337565b80156103ad5773ffffffffffffffffffffffffffffffffffffffff5f54827fffffffffffffffffffffffff00000000000000000000000000000000000000008216175f55167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e05f80a3005b7f1e4fbdf7000000000000000000000000000000000000000000000000000000005f525f60045260245ffd5b346101265760206003193601126101265760043567ffffffffffffffff8111610126578060040160606003198336030112610126577f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005c61124d5760017f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005d610460612383565b610468612556565b505f9061047581806123b9565b5f91505b8082106111c25750506044830191610491838361248d565b9050151561049e826125c5565b916104a8816125c5565b916104b161253e565b506040516104be81612276565b5f808252602082015281156111bb578260011c925b601f196104f86104e2866125ad565b956104f06040519788612314565b8087526125ad565b015f5b818110611160575050821561115857935b601f1961053161051b876125ad565b966105296040519889612314565b8088526125ad565b015f5b8181106111415750506040519561054a876122f7565b865260208601525f604086015260608501525f60808501525f60a085015260c084015260e08301526101008201529261058382806123b9565b90505f5b818110610bcd5750506080840151610613575b7f10dd528db2c49add6545679b976df90d24c035d6a75b17f41b700e8c18ca53646105dd856105eb602082519201516040519384936040855260408501906124de565b9083820360208501526124de565b0390a15f7f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005d005b610659929161063361062b602461066294018361248d565b94909261248d565b94909361065360608801519388516020815160051b910120923691612866565b9061436b565b909391936143a5565b60208151910151905f5260205273ffffffffffffffffffffffffffffffffffffffff8060405f2016911690808203610b9f57505060c0830151610739575b50506040810151906106b1826142f4565b1561070d576105dd907f0a2dc548ed950accb40d5d78541f3954c5e182a8ecf19e581a4f2263f61f59d260207f10dd528db2c49add6545679b976df90d24c035d6a75b17f41b700e8c18ca536494604051908152a1918361059a565b507fdb788c2b000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b602083015160e08401516101008501519060405192610757846122db565b8352602083019080825260408401928352519260209360405161077a8682612314565b5f81529260405161078b8782612314565b5f8152945f915b87848410610a0f57505050506107d063ffffffff821662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b938160011b91808304600214901517156109e25760248661081b63ffffffff6028951662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b9451947fffffffff00000000000000000000000000000000000000000000000000000000826040519882828b019b60e01b168b52805191829101868b015e8801917f919e13001cd3319be5a5a7cb189203be083674acb3fff23d05aae9c3ed86314d8584015260e01b1693846044830152805192839101604883015e010190602482015201848251919201905f5b868282106109ce5750505050906108cb815f949303601f198101835282612314565b604051918291518091835e8101838152039060025afa156102ad575f519160a0840151156108fa575b506106a0565b73ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016803b15610126575f9261097c92604051958694859384937fab750e7500000000000000000000000000000000000000000000000000000000855260606004860152606485019161275a565b907f213b3f40d7c113c1a012072fcd791fa44bf5166a2300121630bd3228e2b008276024840152604483015203915afa80156102ad576109be575b80806108f4565b5f6109c891612314565b816109b7565b8351855293840193909201916001016108a9565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52601160045260245ffd5b9091929695610a62908280610a2e610a288c8851612691565b51613925565b6040519584879551918291018487015e8401908282015f8152815193849201905e01015f815203601f198101835282612314565b9482518760011b90888204600214891517156109e257610a8582610a8b92612691565b51613983565b845190600183018093116109e25760019360048c8193610ab2610a858398610b9698612691565b7fffffffff000000000000000000000000000000000000000000000000000000008380610b0b63ffffffff865160021c1662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b610b4163ffffffff865160021c1662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b95846040519d8b8f82819e519384930191015e8b019260e01b1683830152805192839101602483015e01019260e01b1684830152805192839101600883015e01015f838201520301601f198101835282612314565b96019190610792565b7fe6d44b4c000000000000000000000000000000000000000000000000000000005f5260045260245260445ffd5b610be181610bdb86806123b9565b9061240d565b6020810190610bf082826123b9565b80915060011b818104600214821517156109e257610c0d906125c5565b905f5b8181106110ed575050600160ff82516fffffffffffffffffffffffffffffffff811160071b67ffffffffffffffff82821c1160061b1763ffffffff82821c1160051b1761ffff82821c1160041b178282821c1160031b17600f82821c1160021b177d01010202020203030303030303030000000000000000000000000000000082821c1a179083821b1001161b610ca6816125c5565b915f5b8281106110925750505b600181116110135750610cc590612684565b5191610cd181836123b9565b9190505f5b828110610d2357505050604060019392610d11837f1cc9a0755dd734c1ebfe98b68ece200037e363eb366d0dee04e420e2f23cc010946123b9565b8351928352602083015250a101610587565b610d3781610d3184876123b9565b9061244d565b9a610d40612556565b5060208c0160608d0135805f52600560205260405f205415610fe8575060c08201518792918e9115610e99579282916040610dbb610de996610da660e0610dc4980151608088015160011c90610d9636856126b2565b610da08383612691565b52612691565b505b610db28c806123b9565b909135916127eb565b9101359061298c565b868d60a0610de0610dd58a806123b9565b6080850135916127eb565b9101359061311b565b9a60608c01805160405192610dfd84612276565b60c0810135845260e060208501910135815260405193610e1c85612276565b5f85525f6020860152610e328151835190613c10565b15610e615791610e5391600196959493602083519301519051915192613c72565b602084015282525201610cd6565b604491604051917fb8a0e8a1000000000000000000000000000000000000000000000000000000008352516004830152516024820152fd5b60a083015115610eb8575b92610dc492916040610dbb610de996610da8565b925090610efc73ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016928061248d565b60205f81610f12610f0d368a6126b2565b613925565b604051918183925191829101835e8101838152039060025afa156102ad575f5193803b15610126575f92610f7e92604051968794859384937fab750e7500000000000000000000000000000000000000000000000000000000855260606004860152606485019161275a565b907f919e13001cd3319be5a5a7cb189203be083674acb3fff23d05aae9c3ed86314d6024840152604483015203915afa9283156102ad578e6040610dbb8b93610dc496610de998610fd8575b509396505050919250610ea4565b5f610fe291612314565b5f610fca565b7ff9849ea3000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b60011c5f5b8181106110255750610cb3565b8060011b907f7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff811681036109e25761105d8285612691565b5191600181018091116109e25760019261107a6110819287612691565b5190613e49565b61108b8286612691565b5201611018565b600190825181105f146110bc576110a98184612691565b516110b48287612691565b525b01610ca9565b7fcc1d2f838445db7aec431df9ee8a871f40e7aa5e064fc056633ef8c60fab7b066110e78287612691565b526110b6565b6110fb81610d3187876123b9565b908060011b818104600214821517156109e257602083013561111d8287612691565b52600181018091116109e25761113a608060019401359186612691565b5201610c10565b60209061114c61262d565b82828a01015201610534565b505f9361050c565b60209060405161116f816122bf565b60405161117b816122db565b5f81525f848201525f6040820152815260405161119781612276565b5f81525f84820152838201525f60408201525f6060820152828289010152016104fb565b5f926104d3565b90926111d284610bdb85806123b9565b906111ec6111e360208401846123b9565b938091506123b9565b9280915060011b90808204600214901517156109e25780830361121e5750600191611216916126a5565b930190610479565b827fd3bee78d000000000000000000000000000000000000000000000000000000005f5260045260245260445ffd5b7f3ee5aeb5000000000000000000000000000000000000000000000000000000005f5260045ffd5b34610126575f6003193601126101265760206040517fffffffff000000000000000000000000000000000000000000000000000000007f0000000000000000000000000000000000000000000000000000000000000000168152f35b34610126576020600319360112610126576004355f526005602052602060405f20541515604051908152f35b34610126575f600319360112610126576020600154604051908152f35b34610126576020600319360112610126576004355f526007602052602060405f20541515604051908152f35b34610126575f600319360112610126576004545f1981019081116109e25761136f602091612511565b90549060031b1c604051908152f35b34610126575f60031936011261012657602060ff60025416604051908152f35b34610126576020600319360112610126576004356006548110156113ee5760065f527ff652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f0154604051908152602090f35b7f4e487b71000000000000000000000000000000000000000000000000000000005f52603260045260245ffd5b34610126575f60031936011261012657602073ffffffffffffffffffffffffffffffffffffffff5f5416604051908152f35b346101265760406003193601126101265760043567ffffffffffffffff811161012657806004016060600319833603011261012657602435801515809103610126575a917f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005c61124d5760017f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005d6114e3612383565b6114eb612556565b505f6114f782806123b9565b5f91505b8082106120055750506044850192611513848461248d565b9050151591611521816125c5565b9261152b826125c5565b9261153461253e565b5060405161154181612276565b5f80825260208201528215611ffe578360011c935b601f1961156561051b876125ad565b015f5b818110611fa35750508315611f9b57945b601f1961159e611588886125ad565b97611596604051998a612314565b8089526125ad565b015f5b818110611f84575050604051966115b7886122f7565b875260208701525f604087015260608601525f608086015260a085015260c084015260e0830152610100820152936115ef82806123b9565b90505f5b818110611acb57505060808501516116a5575b61167a847f10dd528db2c49add6545679b976df90d24c035d6a75b17f41b700e8c18ca53646105dd8861164d602082519201516040519384936040855260408501906124de565b0390a15f7f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005d5a90612269565b7f6f149831000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b61065992916116bd61062b60246116dd94018361248d565b94909361065360608901519389516020815160051b910120923691612866565b60208151910151905f5260205273ffffffffffffffffffffffffffffffffffffffff8060405f2016911690808203610b9f57505060c08401516117b6575b505060408201519161172c836142f4565b1561178a576105dd7f10dd528db2c49add6545679b976df90d24c035d6a75b17f41b700e8c18ca5364917f0a2dc548ed950accb40d5d78541f3954c5e182a8ecf19e581a4f2263f61f59d2602061167a96604051908152a193611606565b827fdb788c2b000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b602084015160e085015161010086015190604051926117d4846122db565b835260208301908082526040840192835251926020936040516117f78682612314565b5f8152926040516118088782612314565b5f8152945f915b87848410611a5f575050505061184d63ffffffff821662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b938160011b91808304600214901517156109e25760248661189863ffffffff6028951662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b9451947fffffffff00000000000000000000000000000000000000000000000000000000826040519882828b019b60e01b168b52805191829101868b015e8801917f919e13001cd3319be5a5a7cb189203be083674acb3fff23d05aae9c3ed86314d8584015260e01b1693846044830152805192839101604883015e010190602482015201848251919201905f5b86828210611a4b575050505090611948815f949303601f198101835282612314565b604051918291518091835e8101838152039060025afa156102ad575f519160a085015115611977575b5061171b565b73ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016803b15610126575f926119f992604051958694859384937fab750e7500000000000000000000000000000000000000000000000000000000855260606004860152606485019161275a565b907f213b3f40d7c113c1a012072fcd791fa44bf5166a2300121630bd3228e2b008276024840152604483015203915afa80156102ad57611a3b575b8080611971565b5f611a4591612314565b82611a34565b835185529384019390920191600101611926565b9091929695611a78908280610a2e610a288c8851612691565b9482518760011b90888204600214891517156109e257610a8582611a9b92612691565b845190600183018093116109e25760019360048c8193610ab2610a858398611ac298612691565b9601919061180f565b611ad981610bdb86806123b9565b6020810190611ae882826123b9565b80915060011b818104600214821517156109e257611b05906125c5565b905f5b818110611f30575050600160ff82516fffffffffffffffffffffffffffffffff811160071b67ffffffffffffffff82821c1160061b1763ffffffff82821c1160051b1761ffff82821c1160041b178282821c1160031b17600f82821c1160021b177d01010202020203030303030303030000000000000000000000000000000082821c1a179083821b1001161b611b9e816125c5565b915f5b828110611ed55750505b60018111611e5d5750611bbd90612684565b5191611bc981836123b9565b9190505f5b828110611c1b57505050604060019392611c09837f1cc9a0755dd734c1ebfe98b68ece200037e363eb366d0dee04e420e2f23cc010946123b9565b8351928352602083015250a1016115f3565b611c2981610d3184876123b9565b9b611c32612556565b508c606060208201910135805f52600560205260405f205415610fe8575060c08201518e91889115611d18578382611c85611c9093610da660e0611ca0990151608086015160011c90610d9636856126b2565b60408601359061298c565b9160a0610de0610dd58a806123b9565b9b60608d01805160405192611cb484612276565b60c0810135845260e060208501910135815260405193611cd385612276565b5f85525f6020860152611ce98151835190613c10565b15610e615791611d0a91600196959493602083519301519051915192613c72565b602084015282525201611bce565b60a084015115611d34575b611ca09382611c85611c9093610da8565b9050611d7773ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016928061248d565b60205f81611d88610f0d36886126b2565b604051918183925191829101835e8101838152039060025afa156102ad575f5193803b15610126575f92611df492604051968794859384937fab750e7500000000000000000000000000000000000000000000000000000000855260606004860152606485019161275a565b907f919e13001cd3319be5a5a7cb189203be083674acb3fff23d05aae9c3ed86314d6024840152604483015203915afa9081156102ad578f929389611c85611c9093611ca0978396611e4d575b50935050509350611d23565b5f611e5791612314565b5f611e41565b60011c5f5b818110611e6f5750611bab565b8060011b907f7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff811681036109e257611ea78285612691565b5191600181018091116109e25760019261107a611ec49287612691565b611ece8286612691565b5201611e62565b600190825181105f14611eff57611eec8184612691565b51611ef78287612691565b525b01611ba1565b7fcc1d2f838445db7aec431df9ee8a871f40e7aa5e064fc056633ef8c60fab7b06611f2a8287612691565b52611ef9565b611f3e81610d3187876123b9565b908060011b818104600214821517156109e2576020830135611f608287612691565b52600181018091116109e257611f7d608060019401359186612691565b5201611b08565b602090611f8f61262d565b82828b010152016115a1565b505f94611579565b602090604051611fb2816122bf565b604051611fbe816122db565b5f81525f848201525f60408201528152604051611fda81612276565b5f81525f84820152838201525f60408201525f606082015282828a01015201611568565b5f93611556565b909161201583610bdb86806123b9565b906120266111e360208401846123b9565b9280915060011b90808204600214901517156109e25780830361121e5750600191612050916126a5565b9201906114fb565b34610126575f60031936011261012657612070612337565b5f73ffffffffffffffffffffffffffffffffffffffff81547fffffffffffffffffffffffff000000000000000000000000000000000000000081168355167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e08280a3005b34610126575f600319360112610126576120ec612337565b6120f4612383565b6120fc612383565b740100000000000000000000000000000000000000007fffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff5f5416175f557f62e78cea01bee320cd4e420270b5ea74000d11b0c9f74754ebdbfc544b05a2586020604051338152a1005b34610126575f60031936011261012657602060ff5f5460a01c166040519015158152f35b34610126575f60031936011261012657602060405173ffffffffffffffffffffffffffffffffffffffff7f0000000000000000000000000000000000000000000000000000000000000000168152f35b34610126575f600319360112610126576020600454604051908152f35b34610126575f600319360112610126576020600654604051908152f35b3461012657602060031936011261012657602061136f600435612511565b34610126575f60031936011261012657807f312e302e3000000000000000000000000000000000000000000000000000000060209252f35b919082039182116109e257565b6040810190811067ffffffffffffffff82111761229257604052565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52604160045260245ffd5b6080810190811067ffffffffffffffff82111761229257604052565b6060810190811067ffffffffffffffff82111761229257604052565b610120810190811067ffffffffffffffff82111761229257604052565b90601f601f19910116810190811067ffffffffffffffff82111761229257604052565b73ffffffffffffffffffffffffffffffffffffffff5f5416330361235757565b7f118cdaa7000000000000000000000000000000000000000000000000000000005f523360045260245ffd5b60ff5f5460a01c1661239157565b7fd93c0665000000000000000000000000000000000000000000000000000000005f5260045ffd5b9035907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe181360301821215610126570180359067ffffffffffffffff821161012657602001918160051b3603831361012657565b91908110156113ee5760051b810135907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc181360301821215610126570190565b91908110156113ee5760051b810135907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0181360301821215610126570190565b9035907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe181360301821215610126570180359067ffffffffffffffff82116101265760200191813603831361012657565b90602080835192838152019201905f5b8181106124fb5750505090565b82518452602093840193909201916001016124ee565b6004548110156113ee5760045f5260205f2001905f90565b80548210156113ee575f5260205f2001905f90565b6040519061254b82612276565b5f6020838281520152565b60405190612563826122f7565b6060610100838281528260208201525f604082015260405161258481612276565b5f81525f6020820152838201525f60808201525f60a08201525f60c08201528260e08201520152565b67ffffffffffffffff81116122925760051b60200190565b906125cf826125ad565b6125dc6040519182612314565b828152601f196125ec82946125ad565b0190602036910137565b8115612600570490565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52601260045260245ffd5b6040519061263a826122bf565b815f81525f60208201525f6040820152606060405191612659836122bf565b81835281602084015281604084015281808401520152565b818102929181159184041417156109e257565b8051156113ee5760200190565b80518210156113ee5760209160051b010190565b919082018092116109e257565b809291039160e0831261012657604051906126cc826122bf565b819360608112610126577fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa06040918251612705816122db565b84358152602085013560208201528385013584820152855201126101265760c060609160405161273481612276565b83820135815260808201356020820152602085015260a081013560408501520135910152565b601f8260209493601f1993818652868601375f8582860101520116010190565b90612794906040939695949660608452606084019161275a565b9460208201520152565b9035907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8181360301821215610126570190565b908210156113ee576127e89160051b81019061279e565b90565b909291925f5b81811061282457847f89211474000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b846128308284866127d1565b351461283e576001016127f1565b916127e89394506127d1565b67ffffffffffffffff811161229257601f01601f191660200190565b9291926128728261284a565b916128806040519384612314565b829481845281830111610126578281602093845f960137010152565b9080601f83011215610126578160206127e893359101612866565b9080601f83011215610126578135916128cf836125ad565b926128dd6040519485612314565b80845260208085019160051b830101918383116101265760208101915b83831061290957505050505090565b823567ffffffffffffffff8111610126578201906040601f198388030112610126576040519061293882612276565b6020830135600281101561012657825260408301359167ffffffffffffffff83116101265761296f8860208096958196010161289c565b838201528152019201916128fa565b5f1981146109e25760010190565b93929091612998612556565b5081945f936020820135908082036130ed575060808236031261012657604051936129c2856122bf565b8235948581528260208201526040840194853567ffffffffffffffff81116101265785019060808236031261012657604051916129fe836122bf565b803567ffffffffffffffff811161012657612a1c90369083016128b7565b8352602081013567ffffffffffffffff811161012657612a3f90369083016128b7565b6020840152604081013567ffffffffffffffff811161012657612a6590369083016128b7565b604084015260608101359067ffffffffffffffff821161012657612a8b913691016128b7565b6060830152604083019182526060860192833567ffffffffffffffff811161012657612aba903690890161289c565b6060820152612ac761262d565b505191519060405192612ad9846122bf565b8352600160208401526040830152606082015260c083015115612ffb57612b119150610100830151608084015191610da08383612691565b505b612b2a612b20858561279e565b60408101906123b9565b9050865b818110612df5575050806020612b6792519187612b516080830194855190612691565b520151815191612b608361297e565b9052612691565b52612b718361432d565b15612dc957612b89612b83838361279e565b806123b9565b855b818110612d5a57505050612bac612ba2838361279e565b60208101906123b9565b855b818110612ceb57505050612bc5612b20838361279e565b855b818110612c7857505050612be891612bde9161279e565b60608101906123b9565b839291925b818110612bfb575050505050565b612c0681838661240d565b356002811015612c7457906001809214612c21575b01612bed565b837fa494dac4b7184843583f972e06783e2c3bb47f4f0137b8df52a860df07219f8c612c5b612c5184878a61240d565b602081019061248d565b90612c6c6040519283928784613bf9565b0390a2612c1b565b8580fd5b612c8381838561240d565b356002811015612ce757906001809214612c9e575b01612bc7565b867f9c61b290f631097f56273cf4daf40df1ff9ccc33f101d464837da1f5ae18bd59612cce612c5184878961240d565b90612cdf6040519283928784613bf9565b0390a2612c98565b8780fd5b612cf681838561240d565b356002811015612ce757906001809214612d11575b01612bae565b867f48243873b4752ddcb45e0d7b11c4c266583e5e099a0b798fdd9c1af7d49324f3612d41612c5184878961240d565b90612d526040519283928784613bf9565b0390a2612d0b565b612d6581838561240d565b356002811015612ce757906001809214612d80575b01612b8b565b867f3a134d01c07803003c63301717ddc4612e6c47ae408eeea3222cded532d02ae6612db0612c5184878961240d565b90612dc16040519283928784613bf9565b0390a2612d7a565b602484847f39a940c5000000000000000000000000000000000000000000000000000000008252600452fd5b612e09612c5182610bdb612b208a8a61279e565b810190606081830312612ff75780359173ffffffffffffffffffffffffffffffffffffffff8316809303612ff357602082013567ffffffffffffffff8111612fef5781612e5791840161289c565b9160408101359067ffffffffffffffff8211612fe057612e7892910161289c565b90604051917f33a89203000000000000000000000000000000000000000000000000000000008352876004840152604060248401528b8380612ebd6044820186614000565b038183885af1928315612fe4578c93612f60575b50825160208401208151602083012003612f25575060019392917fcddb327adb31fe5437df2a8c68301bb13a6baae432a804838caaf682506aadf191612f1c60405192839283614025565b0390a201612b2e565b9050612f5c6040519283927fc504fada00000000000000000000000000000000000000000000000000000000845260048401614025565b0390fd5b9092503d808d833e612f728183612314565b810190602081830312612fe05780519067ffffffffffffffff8211612fdc570181601f82011215612fe057805190612fa98261284a565b92612fb76040519485612314565b82845260208383010111612fdc57818e9260208093018386015e83010152915f612ed1565b8d80fd5b8c80fd5b6040513d8e823e3d90fd5b8b80fd5b8a80fd5b8980fd5b60a08301511561300d575b5050612b13565b61305e9060205f8161305673ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016968a61248d565b959094613983565b604051918183925191829101835e8101838152039060025afa156102ad575f5192803b15610126575f9286926130c3604051968795869485947fab750e750000000000000000000000000000000000000000000000000000000086526004860161277a565b03915afa80156102ad576130d8575b80613006565b6130e59196505f90612314565b5f945f6130d2565b7f18f639d8000000000000000000000000000000000000000000000000000000005f5260045260245260445ffd5b939290915f94613129612556565b5082956020820135948086036138f557506080823603126101265760405194613151866122bf565b8235958681528160208201526040840194853567ffffffffffffffff811161012657850190608082360312610126576040519161318d836122bf565b803567ffffffffffffffff8111610126576131ab90369083016128b7565b8352602081013567ffffffffffffffff8111610126576131ce90369083016128b7565b6020840152604081013567ffffffffffffffff8111610126576131f490369083016128b7565b604084015260608101359067ffffffffffffffff82116101265761321a913691016128b7565b6060830152604083019182526060860192833567ffffffffffffffff811161012657613249903690890161289c565b606082015261325661262d565b505191519060405192613268846122bf565b83525f60208401526040830152606082015260c08701511561380b5761329f9150610100870151608088015191610da08383612691565b505b6132ae612b20858561279e565b9050825b8181106136505750506132e38551876132d16080890192835190612691565b526020870151815191612b608361297e565b529260ff60025416906001546132f88161297e565b6001559186925f5b8281106135aa575050600154600160ff600254161b14613551575b506040015261332d612b83838361279e565b90845b8281106134e257505050613347612ba2838361279e565b90845b82811061347357505050613361612b20838361279e565b90845b8281106134005750505061337b91612bde9161279e565b9290825b84811061338d575050505050565b61339881868461240d565b3560028110156133fc579060018092146133b3575b0161337f565b837fa494dac4b7184843583f972e06783e2c3bb47f4f0137b8df52a860df07219f8c6133e3612c51848a8861240d565b906133f46040519283928784613bf9565b0390a26133ad565b8480fd5b61340b81848461240d565b35600281101561346f57906001809214613426575b01613364565b877f9c61b290f631097f56273cf4daf40df1ff9ccc33f101d464837da1f5ae18bd59613456612c5184888861240d565b906134676040519283928784613bf9565b0390a2613420565b8680fd5b61347e81848461240d565b35600281101561346f57906001809214613499575b0161334a565b877f48243873b4752ddcb45e0d7b11c4c266583e5e099a0b798fdd9c1af7d49324f36134c9612c5184888861240d565b906134da6040519283928784613bf9565b0390a2613493565b6134ed81848461240d565b35600281101561346f57906001809214613508575b01613330565b877f3a134d01c07803003c63301717ddc4612e6c47ae408eeea3222cded532d02ae6613538612c5184888861240d565b906135496040519283928784613bf9565b0390a2613502565b90916002549068010000000000000000821015612292576040926135808360016135a395016002556002612529565b81549060031b905f1985831b921b191617905560035f5260205f20015490613e49565b919061331b565b9093600190818616613618577f405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace830181905560035f527fc2575a0e9e593c00f959f8c92f12db2869c3395a3b0502d05e2516446f71f85b83015461360d91613e49565b945b811c9101613300565b60025f527f405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace83015461364a9190613e49565b9461360f565b613664612c5182610bdb612b208a8a61279e565b810190606081830312612c745780359173ffffffffffffffffffffffffffffffffffffffff831680930361346f57602082013567ffffffffffffffff8111612ce757816136b291840161289c565b9160408101359067ffffffffffffffff82116137fc576136d392910161289c565b90604051917f33a89203000000000000000000000000000000000000000000000000000000008352866004840152604060248401528783806137186044820186614000565b038183885af1928315613800578893613780575b50825160208401208151602083012003612f25575060019392917fcddb327adb31fe5437df2a8c68301bb13a6baae432a804838caaf682506aadf19161377760405192839283614025565b0390a2016132b2565b9092503d8089833e6137928183612314565b8101906020818303126137fc5780519067ffffffffffffffff8211612ff7570181601f820112156137fc578051906137c98261284a565b926137d76040519485612314565b82845260208383010111612ff757818a9260208093018386015e83010152915f61372c565b8880fd5b6040513d8a823e3d90fd5b60a08701511561381d575b50506132a1565b6138669060205f8161305673ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016968a61248d565b604051918183925191829101835e8101838152039060025afa156102ad575f5192803b15610126575f9285926138cb604051968795869485947fab750e750000000000000000000000000000000000000000000000000000000086526004860161277a565b03915afa80156102ad576138e0575b80613816565b6138ed9192505f90612314565b5f905f6138da565b85907f18f639d8000000000000000000000000000000000000000000000000000000005f5260045260245260445ffd5b80518051916040602083015192015160208201516020815191015191606060408501519401519460405196602088015260408701526060860152608085015260a084015260c083015260e082015260e081526127e861010082612314565b60608101518151602083015190919015613bf05760406301000000935b015190805190815163ffffffff166139da9062ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b916139e490613e8c565b6020820151805163ffffffff16613a1d9062ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b90613a2790613e8c565b90604084015192835163ffffffff16613a629062ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b93613a6c90613e8c565b946060015195865163ffffffff16613aa69062ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b96613ab090613e8c565b976040519a8b9a60208c015260e01b7fffffffff000000000000000000000000000000000000000000000000000000001660408b015260448a015260e01b7fffffffff000000000000000000000000000000000000000000000000000000001660648901528051602081920160688a015e87019060e01b7fffffffff0000000000000000000000000000000000000000000000000000000016606882015281516020819301606c83015e016068019060e01b7fffffffff0000000000000000000000000000000000000000000000000000000016600482015281516020819301600883015e016004019060e01b7fffffffff0000000000000000000000000000000000000000000000000000000016600482015281516020819301600883015e01600401600481015f905203600401601f19810182526127e89082612314565b60405f936139a0565b6040906127e894928152816020820152019161275a565b80158015613c62575b8015613c5a575b8015613c4a575b613c44576401000003d01960078180938181800909089180091490565b50505f90565b506401000003d019821015613c27565b508115613c20565b506401000003d019811015613c19565b92939290915f90808303613e2c5750506401000003d0195f948308613c9b57505090505f905f90565b5f613cad926401000003d0199261427d565b939091905b8415158581613e1b575b5080613e13575b15613db55780948060016401000003d01984925b613d2b575050505080613cfe5750906401000003d019809281808780098092099509900990565b807f4e487b7100000000000000000000000000000000000000000000000000000000602492526012600452fd5b613d3984829a94959a6125f6565b918094613d88576401000003d0199083096401000003d01903906401000003d01982116109e257613d7a6401000003d019613d8093889608959a8094612671565b90612269565b929083613cd7565b6024867f4e487b710000000000000000000000000000000000000000000000000000000081526012600452fd5b60646040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152600e60248201527f496e76616c6964206e756d6265720000000000000000000000000000000000006044820152fd5b506001613cc3565b6401000003d019915014155f613cbc565b613e40936401000003d01993969296614082565b93909190613cb2565b5f9060209260405190848201928352604082015260408152613e6c606082612314565b604051918291518091835e8101838152039060025afa156102ad575f5190565b8051606092915f915b808310613ea157505050565b909193613ee863ffffffff6020613eb88887612691565b5101515160021c1662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b906020613ef58786612691565b510151613f028786612691565b51516002811015613fd3576004602093613fca937fffffffff000000000000000000000000000000000000000000000000000000008680600199613f69879862ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b94846040519b888d995191829101868b015e88019260e01b1683830152805192839101602483015e01019160e01b168382015203017fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe4810184520182612314565b94019190613e95565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52602160045260245ffd5b90601f19601f602080948051918291828752018686015e5f8582860101520116010190565b909161403c6127e893604084526040840190614000565b916020818403910152614000565b8054680100000000000000008110156122925761406c91600182018155612529565b5f19829392549160031b92831b921b1916179055565b949291851580614275575b61426957801580614261575b614257576040516080916140ad8383612314565b8236833786156126005786948580928180600180098087529781896001099c602088019d8e5282604089019d8e8c8152516001099160608a019283526040519e8f6140f7906122bf565b5190098d525190099460208b019586525190099860408901998a5251900960608701908152865188511480159061424b575b156141ed57849283808093816040519c856141458f9788612314565b368737518c516141559083612269565b900884525185516141669083612269565b90089860208301998a5281808b8180808089518a5190099360408a019485528185518b5190096060909a01998a5251800988516141a39083612269565b900881808751855190096002096141ba9083612269565b90089c519351905190096141ce8c83612269565b900890099251905190096141e29083612269565b900894510991929190565b60646040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601e60248201527f557365206a6163446f75626c652066756e6374696f6e20696e737465616400006044820152fd5b50815181511415614129565b5092506001919050565b508215614099565b94509092506001919050565b50811561408d565b9391929092811561260057600182806142ea818080809781806142da9e818f81818192099a8b96818f8180828193099a880960040998800990099280096003090891816142cd8183800882612269565b81858009089e8f83612269565b9008900993800960080983612269565b9008940960020990565b805f52600560205260405f2054155f146143285761431381600461404a565b600454905f52600560205260405f2055600190565b505f90565b805f52600760205260405f2054155f146143285761434c81600661404a565b600654905f52600760205260405f2055600190565b60041115613fd357565b815191906041830361439b576143949250602082015190606060408401519301515f1a9061446c565b9192909190565b50505f9160029190565b6143ae81614361565b806143b7575050565b6143c081614361565b600181036143f0577ff645eedf000000000000000000000000000000000000000000000000000000005f5260045ffd5b6143f981614361565b6002810361442d57507ffce698f7000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b60039061443981614361565b146144415750565b7fd78bce0c000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b91907f7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a084116144f0579160209360809260ff5f9560405194855216868401526040830152606082015282805260015afa156102ad575f5173ffffffffffffffffffffffffffffffffffffffff8116156144e657905f905f90565b505f906001905f90565b5050505f916003919056fcedd375898c00de52e8f13b0b8e32ad9c1577fe333b1d8f9c932ae1bca6dac3cc1d2f838445db7aec431df9ee8a871f40e7aa5e064fc056633ef8c60fab7b06
    /// ```
    #[rustfmt::skip]
    #[allow(clippy::all)]
    pub static BYTECODE: alloy_sol_types::private::Bytes = alloy_sol_types::private::Bytes::from_static(
        b"`\xC0\x80`@R4a\x028W``\x81aI4\x808\x03\x80\x91a\0\x1F\x82\x85a\x03\x08V[\x839\x81\x01\x03\x12a\x028W\x80Q`\x01`\x01`\xA0\x1B\x03\x81\x16\x91\x82\x82\x03a\x028W` \x81\x01Q`\x01`\x01`\xE0\x1B\x03\x19\x81\x16\x91\x82\x82\x03a\x028W`@\x01Q`\x01`\x01`\xA0\x1B\x03\x81\x16\x90\x81\x90\x03a\x028W\x80\x15a\x02\xF5W_\x80T`\x01`\x01`\xA0\x1B\x03\x19\x81\x16\x83\x17\x82U`\x01`\x01`\xA0\x1B\x03\x16\x90\x7F\x8B\xE0\x07\x9CS\x16Y\x14\x13D\xCD\x1F\xD0\xA4\xF2\x84\x19I\x7F\x97\"\xA3\xDA\xAF\xE3\xB4\x18okdW\xE0\x90\x80\xA3a\x01\0`\x03U__Q` aI\x14_9_Q\x90_R[a\x01\0\x82\x10a\x02\xA1WPP_`\x01Ua\0\xDEa\x03?V[P\x7F\n-\xC5H\xED\x95\n\xCC\xB4\r]xT\x1F9T\xC5\xE1\x82\xA8\xEC\xF1\x9EX\x1AO\"c\xF6\x1FY\xD2` `@Q_Q` aI\x14_9_Q\x90_R\x81R\xA1\x83\x15a\x02\x92W` \x92`\x80R`\xA0R`$`@Q\x80\x94\x81\x93c<\xAD\xF4I`\xE0\x1B\x83R`\x04\x83\x01RZ\xFA\x90\x81\x15a\x02DW_\x91a\x02OW[P`@Qc\\\x97Z\xBB`\xE0\x1B\x81R\x90` \x90\x82\x90`\x04\x90\x82\x90`\x01`\x01`\xA0\x1B\x03\x16Z\xFA\x90\x81\x15a\x02DW_\x91a\x02\x05W[P`\xFF_T`\xA0\x1C\x16\x90\x81\x15a\x01\xFDW[Pa\x01\xEEW`@QaD\xFB\x90\x81a\x03\xF9\x829`\x80Q\x81\x81\x81a\x01\xC5\x01R\x81\x81a\t\x11\x01R\x81\x81a\x0E\xD5\x01R\x81\x81a\x19\x8E\x01R\x81\x81a\x1DP\x01R\x81\x81a!\xB5\x01R\x81\x81a0/\x01Ra8?\x01R`\xA0Q\x81\x81\x81a\x01\x83\x01Ra\x12\xAD\x01R\xF3[c\x0B\x1D8\xA3`\xE0\x1B_R`\x04_\xFD[\x90P_a\x01\x90V[\x90P` \x81=` \x11a\x02<W[\x81a\x02 ` \x93\x83a\x03\x08V[\x81\x01\x03\x12a\x028WQ\x80\x15\x15\x81\x03a\x028W_a\x01\x7FV[_\x80\xFD[=\x91Pa\x02\x13V[`@Q=_\x82>=\x90\xFD[\x90P` \x81=` \x11a\x02\x8AW[\x81a\x02j` \x93\x83a\x03\x08V[\x81\x01\x03\x12a\x028WQ`\x01`\x01`\xA0\x1B\x03\x81\x16\x81\x03a\x028W` a\x01MV[=\x91Pa\x02]V[cg\xA5\xA7\x17`\xE1\x1B_R`\x04_\xFD[_` \x91`\x03\x82R\x80\x84\x84\x84 \x01U`@Q\x83\x81\x01\x91\x80\x83R`@\x82\x01R`@\x81Ra\x02\xCE``\x82a\x03\x08V[`@Q\x91\x82\x91Q\x80\x91\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02DW`\x01_Q\x91\x01\x90a\0\xC7V[c\x1EO\xBD\xF7`\xE0\x1B_R_`\x04R`$_\xFD[`\x1F\x90\x91\x01`\x1F\x19\x16\x81\x01\x90`\x01`\x01`@\x1B\x03\x82\x11\x90\x82\x10\x17a\x03+W`@RV[cNH{q`\xE0\x1B_R`A`\x04R`$_\xFD[_Q` aI\x14_9_Q\x90_R_R`\x05` R_Q` aH\xF4_9_Q\x90_RTa\x03\xF4W`\x04Th\x01\0\0\0\0\0\0\0\0\x81\x10\x15a\x03+W`\x01\x81\x01\x80`\x04U\x81\x10\x15a\x03\xE0W_Q` aI\x14_9_Q\x90_R\x7F\x8A5\xAC\xFB\xC1_\xF8\x1A9\xAE}4O\xD7\t\xF2\x8E\x86\0\xB4\xAA\x8Ce\xC6\xB6K\xFE\x7F\xE3k\xD1\x9B\x90\x91\x01\x81\x90U`\x04T_\x91\x90\x91R`\x05` R_Q` aH\xF4_9_Q\x90_RU`\x01\x90V[cNH{q`\xE0\x1B_R`2`\x04R`$_\xFD[_\x90V\xFE`\x80\x80`@R`\x046\x10\x15a\0\x12W_\x80\xFD[_5`\xE0\x1C\x90\x81c\r\x8En,\x14a\"1WP\x80c1\xEEbB\x14a\"\x13W\x80c@\xF3MB\x14a!\xF6W\x80cY\xBA\x92X\x14a!\xD9W\x80c[fk\x1E\x14a!\x89W\x80c\\\x97Z\xBB\x14a!eW\x80cc\xA5\x99\xA4\x14a \xD4W\x80cqP\x18\xA6\x14a XW\x80c\x82\xD3*\xD8\x14a\x14MW\x80c\x8D\xA5\xCB[\x14a\x14\x1BW\x80c\x9A\xD9\x1DL\x14a\x13\x9EW\x80c\xA0`V\xF7\x14a\x13~W\x80c\xBD\xEBD-\x14a\x13FW\x80c\xC1\xB0\xBE\xD7\x14a\x13\x1AW\x80c\xC4IV\xD1\x14a\x12\xFDW\x80c\xC8y\xDB\xE4\x14a\x12\xD1W\x80c\xE38E\xCF\x14a\x12uW\x80c\xED<\xF9\x1F\x14a\x03\xD9W\x80c\xF2\xFD\xE3\x8B\x14a\x03\x08W\x80c\xFD\xDDH7\x14a\x01*Wc\xFE\x18\xAB\x91\x14a\x01\x03W_\x80\xFD[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\x01`\xFF`\x02T\x16\x1B`@Q\x90\x81R\xF3[_\x80\xFD[4a\x01&W_`\x03\x196\x01\x12a\x01&W`@Q\x7F<\xAD\xF4I\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`\x04\x82\x01R` \x81`$\x81s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16Z\xFA\x90\x81\x15a\x02\xADW_\x91a\x02\xB8W[P` s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x91`\x04`@Q\x80\x94\x81\x93\x7F\\\x97Z\xBB\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83R\x16Z\xFA\x80\x15a\x02\xADW_\x90a\x02qW[` \x91P`\xFF_T`\xA0\x1C\x16\x90\x81\x15a\x02iW[P`@Q\x90\x15\x15\x81R\xF3[\x90P\x82a\x02^V[P` \x81=` \x11a\x02\xA5W[\x81a\x02\x8B` \x93\x83a#\x14V[\x81\x01\x03\x12a\x01&WQ\x80\x15\x15\x81\x03a\x01&W` \x90a\x02JV[=\x91Pa\x02~V[`@Q=_\x82>=\x90\xFD[\x90P` \x81=` \x11a\x03\0W[\x81a\x02\xD3` \x93\x83a#\x14V[\x81\x01\x03\x12a\x01&WQs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x81\x03a\x01&W` a\x01\xF5V[=\x91Pa\x02\xC6V[4a\x01&W` `\x03\x196\x01\x12a\x01&W`\x045s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x80\x91\x03a\x01&Wa\x03Ba#7V[\x80\x15a\x03\xADWs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF_T\x82\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82\x16\x17_U\x16\x7F\x8B\xE0\x07\x9CS\x16Y\x14\x13D\xCD\x1F\xD0\xA4\xF2\x84\x19I\x7F\x97\"\xA3\xDA\xAF\xE3\xB4\x18okdW\xE0_\x80\xA3\0[\x7F\x1EO\xBD\xF7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R_`\x04R`$_\xFD[4a\x01&W` `\x03\x196\x01\x12a\x01&W`\x045g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x80`\x04\x01```\x03\x19\x836\x03\x01\x12a\x01&W\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0\\a\x12MW`\x01\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0]a\x04`a#\x83V[a\x04ha%VV[P_\x90a\x04u\x81\x80a#\xB9V[_\x91P[\x80\x82\x10a\x11\xC2WPP`D\x83\x01\x91a\x04\x91\x83\x83a$\x8DV[\x90P\x15\x15a\x04\x9E\x82a%\xC5V[\x91a\x04\xA8\x81a%\xC5V[\x91a\x04\xB1a%>V[P`@Qa\x04\xBE\x81a\"vV[_\x80\x82R` \x82\x01R\x81\x15a\x11\xBBW\x82`\x01\x1C\x92[`\x1F\x19a\x04\xF8a\x04\xE2\x86a%\xADV[\x95a\x04\xF0`@Q\x97\x88a#\x14V[\x80\x87Ra%\xADV[\x01_[\x81\x81\x10a\x11`WPP\x82\x15a\x11XW\x93[`\x1F\x19a\x051a\x05\x1B\x87a%\xADV[\x96a\x05)`@Q\x98\x89a#\x14V[\x80\x88Ra%\xADV[\x01_[\x81\x81\x10a\x11AWPP`@Q\x95a\x05J\x87a\"\xF7V[\x86R` \x86\x01R_`@\x86\x01R``\x85\x01R_`\x80\x85\x01R_`\xA0\x85\x01R`\xC0\x84\x01R`\xE0\x83\x01Ra\x01\0\x82\x01R\x92a\x05\x83\x82\x80a#\xB9V[\x90P_[\x81\x81\x10a\x0B\xCDWPP`\x80\x84\x01Qa\x06\x13W[\x7F\x10\xDDR\x8D\xB2\xC4\x9A\xDDeEg\x9B\x97m\xF9\r$\xC05\xD6\xA7[\x17\xF4\x1Bp\x0E\x8C\x18\xCASda\x05\xDD\x85a\x05\xEB` \x82Q\x92\x01Q`@Q\x93\x84\x93`@\x85R`@\x85\x01\x90a$\xDEV[\x90\x83\x82\x03` \x85\x01Ra$\xDEV[\x03\x90\xA1_\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0]\0[a\x06Y\x92\x91a\x063a\x06+`$a\x06b\x94\x01\x83a$\x8DV[\x94\x90\x92a$\x8DV[\x94\x90\x93a\x06S``\x88\x01Q\x93\x88Q` \x81Q`\x05\x1B\x91\x01 \x926\x91a(fV[\x90aCkV[\x90\x93\x91\x93aC\xA5V[` \x81Q\x91\x01Q\x90_R` Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x80`@_ \x16\x91\x16\x90\x80\x82\x03a\x0B\x9FWPP`\xC0\x83\x01Qa\x079W[PP`@\x81\x01Q\x90a\x06\xB1\x82aB\xF4V[\x15a\x07\rWa\x05\xDD\x90\x7F\n-\xC5H\xED\x95\n\xCC\xB4\r]xT\x1F9T\xC5\xE1\x82\xA8\xEC\xF1\x9EX\x1AO\"c\xF6\x1FY\xD2` \x7F\x10\xDDR\x8D\xB2\xC4\x9A\xDDeEg\x9B\x97m\xF9\r$\xC05\xD6\xA7[\x17\xF4\x1Bp\x0E\x8C\x18\xCASd\x94`@Q\x90\x81R\xA1\x91\x83a\x05\x9AV[P\x7F\xDBx\x8C+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[` \x83\x01Q`\xE0\x84\x01Qa\x01\0\x85\x01Q\x90`@Q\x92a\x07W\x84a\"\xDBV[\x83R` \x83\x01\x90\x80\x82R`@\x84\x01\x92\x83RQ\x92` \x93`@Qa\x07z\x86\x82a#\x14V[_\x81R\x92`@Qa\x07\x8B\x87\x82a#\x14V[_\x81R\x94_\x91[\x87\x84\x84\x10a\n\x0FWPPPPa\x07\xD0c\xFF\xFF\xFF\xFF\x82\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x93\x81`\x01\x1B\x91\x80\x83\x04`\x02\x14\x90\x15\x17\x15a\t\xE2W`$\x86a\x08\x1Bc\xFF\xFF\xFF\xFF`(\x95\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x94Q\x94\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82`@Q\x98\x82\x82\x8B\x01\x9B`\xE0\x1B\x16\x8BR\x80Q\x91\x82\x91\x01\x86\x8B\x01^\x88\x01\x91\x7F\x91\x9E\x13\0\x1C\xD31\x9B\xE5\xA5\xA7\xCB\x18\x92\x03\xBE\x086t\xAC\xB3\xFF\xF2=\x05\xAA\xE9\xC3\xED\x861M\x85\x84\x01R`\xE0\x1B\x16\x93\x84`D\x83\x01R\x80Q\x92\x83\x91\x01`H\x83\x01^\x01\x01\x90`$\x82\x01R\x01\x84\x82Q\x91\x92\x01\x90_[\x86\x82\x82\x10a\t\xCEWPPPP\x90a\x08\xCB\x81_\x94\x93\x03`\x1F\x19\x81\x01\x83R\x82a#\x14V[`@Q\x91\x82\x91Q\x80\x91\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xADW_Q\x91`\xA0\x84\x01Q\x15a\x08\xFAW[Pa\x06\xA0V[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x80;\x15a\x01&W_\x92a\t|\x92`@Q\x95\x86\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R```\x04\x86\x01R`d\x85\x01\x91a'ZV[\x90\x7F!;?@\xD7\xC1\x13\xC1\xA0\x12\x07/\xCDy\x1F\xA4K\xF5\x16j#\0\x12\x160\xBD2(\xE2\xB0\x08'`$\x84\x01R`D\x83\x01R\x03\x91Z\xFA\x80\x15a\x02\xADWa\t\xBEW[\x80\x80a\x08\xF4V[_a\t\xC8\x91a#\x14V[\x81a\t\xB7V[\x83Q\x85R\x93\x84\x01\x93\x90\x92\x01\x91`\x01\x01a\x08\xA9V[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x11`\x04R`$_\xFD[\x90\x91\x92\x96\x95a\nb\x90\x82\x80a\n.a\n(\x8C\x88Qa&\x91V[Qa9%V[`@Q\x95\x84\x87\x95Q\x91\x82\x91\x01\x84\x87\x01^\x84\x01\x90\x82\x82\x01_\x81R\x81Q\x93\x84\x92\x01\x90^\x01\x01_\x81R\x03`\x1F\x19\x81\x01\x83R\x82a#\x14V[\x94\x82Q\x87`\x01\x1B\x90\x88\x82\x04`\x02\x14\x89\x15\x17\x15a\t\xE2Wa\n\x85\x82a\n\x8B\x92a&\x91V[Qa9\x83V[\x84Q\x90`\x01\x83\x01\x80\x93\x11a\t\xE2W`\x01\x93`\x04\x8C\x81\x93a\n\xB2a\n\x85\x83\x98a\x0B\x96\x98a&\x91V[\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83\x80a\x0B\x0Bc\xFF\xFF\xFF\xFF\x86Q`\x02\x1C\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[a\x0BAc\xFF\xFF\xFF\xFF\x86Q`\x02\x1C\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x95\x84`@Q\x9D\x8B\x8F\x82\x81\x9EQ\x93\x84\x93\x01\x91\x01^\x8B\x01\x92`\xE0\x1B\x16\x83\x83\x01R\x80Q\x92\x83\x91\x01`$\x83\x01^\x01\x01\x92`\xE0\x1B\x16\x84\x83\x01R\x80Q\x92\x83\x91\x01`\x08\x83\x01^\x01\x01_\x83\x82\x01R\x03\x01`\x1F\x19\x81\x01\x83R\x82a#\x14V[\x96\x01\x91\x90a\x07\x92V[\x7F\xE6\xD4KL\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$R`D_\xFD[a\x0B\xE1\x81a\x0B\xDB\x86\x80a#\xB9V[\x90a$\rV[` \x81\x01\x90a\x0B\xF0\x82\x82a#\xB9V[\x80\x91P`\x01\x1B\x81\x81\x04`\x02\x14\x82\x15\x17\x15a\t\xE2Wa\x0C\r\x90a%\xC5V[\x90_[\x81\x81\x10a\x10\xEDWPP`\x01`\xFF\x82Qo\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11`\x07\x1Bg\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x82\x1C\x11`\x06\x1B\x17c\xFF\xFF\xFF\xFF\x82\x82\x1C\x11`\x05\x1B\x17a\xFF\xFF\x82\x82\x1C\x11`\x04\x1B\x17\x82\x82\x82\x1C\x11`\x03\x1B\x17`\x0F\x82\x82\x1C\x11`\x02\x1B\x17}\x01\x01\x02\x02\x02\x02\x03\x03\x03\x03\x03\x03\x03\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82\x82\x1C\x1A\x17\x90\x83\x82\x1B\x10\x01\x16\x1Ba\x0C\xA6\x81a%\xC5V[\x91_[\x82\x81\x10a\x10\x92WPP[`\x01\x81\x11a\x10\x13WPa\x0C\xC5\x90a&\x84V[Q\x91a\x0C\xD1\x81\x83a#\xB9V[\x91\x90P_[\x82\x81\x10a\r#WPPP`@`\x01\x93\x92a\r\x11\x83\x7F\x1C\xC9\xA0u]\xD74\xC1\xEB\xFE\x98\xB6\x8E\xCE \x007\xE3c\xEB6m\r\xEE\x04\xE4 \xE2\xF2<\xC0\x10\x94a#\xB9V[\x83Q\x92\x83R` \x83\x01RP\xA1\x01a\x05\x87V[a\r7\x81a\r1\x84\x87a#\xB9V[\x90a$MV[\x9Aa\r@a%VV[P` \x8C\x01``\x8D\x015\x80_R`\x05` R`@_ T\x15a\x0F\xE8WP`\xC0\x82\x01Q\x87\x92\x91\x8E\x91\x15a\x0E\x99W\x92\x82\x91`@a\r\xBBa\r\xE9\x96a\r\xA6`\xE0a\r\xC4\x98\x01Q`\x80\x88\x01Q`\x01\x1C\x90a\r\x966\x85a&\xB2V[a\r\xA0\x83\x83a&\x91V[Ra&\x91V[P[a\r\xB2\x8C\x80a#\xB9V[\x90\x915\x91a'\xEBV[\x91\x015\x90a)\x8CV[\x86\x8D`\xA0a\r\xE0a\r\xD5\x8A\x80a#\xB9V[`\x80\x85\x015\x91a'\xEBV[\x91\x015\x90a1\x1BV[\x9A``\x8C\x01\x80Q`@Q\x92a\r\xFD\x84a\"vV[`\xC0\x81\x015\x84R`\xE0` \x85\x01\x91\x015\x81R`@Q\x93a\x0E\x1C\x85a\"vV[_\x85R_` \x86\x01Ra\x0E2\x81Q\x83Q\x90a<\x10V[\x15a\x0EaW\x91a\x0ES\x91`\x01\x96\x95\x94\x93` \x83Q\x93\x01Q\x90Q\x91Q\x92a<rV[` \x84\x01R\x82RR\x01a\x0C\xD6V[`D\x91`@Q\x91\x7F\xB8\xA0\xE8\xA1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83RQ`\x04\x83\x01RQ`$\x82\x01R\xFD[`\xA0\x83\x01Q\x15a\x0E\xB8W[\x92a\r\xC4\x92\x91`@a\r\xBBa\r\xE9\x96a\r\xA8V[\x92P\x90a\x0E\xFCs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x92\x80a$\x8DV[` _\x81a\x0F\x12a\x0F\r6\x8Aa&\xB2V[a9%V[`@Q\x91\x81\x83\x92Q\x91\x82\x91\x01\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xADW_Q\x93\x80;\x15a\x01&W_\x92a\x0F~\x92`@Q\x96\x87\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R```\x04\x86\x01R`d\x85\x01\x91a'ZV[\x90\x7F\x91\x9E\x13\0\x1C\xD31\x9B\xE5\xA5\xA7\xCB\x18\x92\x03\xBE\x086t\xAC\xB3\xFF\xF2=\x05\xAA\xE9\xC3\xED\x861M`$\x84\x01R`D\x83\x01R\x03\x91Z\xFA\x92\x83\x15a\x02\xADW\x8E`@a\r\xBB\x8B\x93a\r\xC4\x96a\r\xE9\x98a\x0F\xD8W[P\x93\x96PPP\x91\x92Pa\x0E\xA4V[_a\x0F\xE2\x91a#\x14V[_a\x0F\xCAV[\x7F\xF9\x84\x9E\xA3\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[`\x01\x1C_[\x81\x81\x10a\x10%WPa\x0C\xB3V[\x80`\x01\x1B\x90\x7F\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x81\x03a\t\xE2Wa\x10]\x82\x85a&\x91V[Q\x91`\x01\x81\x01\x80\x91\x11a\t\xE2W`\x01\x92a\x10za\x10\x81\x92\x87a&\x91V[Q\x90a>IV[a\x10\x8B\x82\x86a&\x91V[R\x01a\x10\x18V[`\x01\x90\x82Q\x81\x10_\x14a\x10\xBCWa\x10\xA9\x81\x84a&\x91V[Qa\x10\xB4\x82\x87a&\x91V[R[\x01a\x0C\xA9V[\x7F\xCC\x1D/\x83\x84E\xDBz\xECC\x1D\xF9\xEE\x8A\x87\x1F@\xE7\xAA^\x06O\xC0Vc>\xF8\xC6\x0F\xAB{\x06a\x10\xE7\x82\x87a&\x91V[Ra\x10\xB6V[a\x10\xFB\x81a\r1\x87\x87a#\xB9V[\x90\x80`\x01\x1B\x81\x81\x04`\x02\x14\x82\x15\x17\x15a\t\xE2W` \x83\x015a\x11\x1D\x82\x87a&\x91V[R`\x01\x81\x01\x80\x91\x11a\t\xE2Wa\x11:`\x80`\x01\x94\x015\x91\x86a&\x91V[R\x01a\x0C\x10V[` \x90a\x11La&-V[\x82\x82\x8A\x01\x01R\x01a\x054V[P_\x93a\x05\x0CV[` \x90`@Qa\x11o\x81a\"\xBFV[`@Qa\x11{\x81a\"\xDBV[_\x81R_\x84\x82\x01R_`@\x82\x01R\x81R`@Qa\x11\x97\x81a\"vV[_\x81R_\x84\x82\x01R\x83\x82\x01R_`@\x82\x01R_``\x82\x01R\x82\x82\x89\x01\x01R\x01a\x04\xFBV[_\x92a\x04\xD3V[\x90\x92a\x11\xD2\x84a\x0B\xDB\x85\x80a#\xB9V[\x90a\x11\xECa\x11\xE3` \x84\x01\x84a#\xB9V[\x93\x80\x91Pa#\xB9V[\x92\x80\x91P`\x01\x1B\x90\x80\x82\x04`\x02\x14\x90\x15\x17\x15a\t\xE2W\x80\x83\x03a\x12\x1EWP`\x01\x91a\x12\x16\x91a&\xA5V[\x93\x01\x90a\x04yV[\x82\x7F\xD3\xBE\xE7\x8D\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$R`D_\xFD[\x7F>\xE5\xAE\xB5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04_\xFD[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `@Q\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x81R\xF3[4a\x01&W` `\x03\x196\x01\x12a\x01&W`\x045_R`\x05` R` `@_ T\x15\x15`@Q\x90\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\x01T`@Q\x90\x81R\xF3[4a\x01&W` `\x03\x196\x01\x12a\x01&W`\x045_R`\x07` R` `@_ T\x15\x15`@Q\x90\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W`\x04T_\x19\x81\x01\x90\x81\x11a\t\xE2Wa\x13o` \x91a%\x11V[\x90T\x90`\x03\x1B\x1C`@Q\x90\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\xFF`\x02T\x16`@Q\x90\x81R\xF3[4a\x01&W` `\x03\x196\x01\x12a\x01&W`\x045`\x06T\x81\x10\x15a\x13\xEEW`\x06_R\x7F\xF6R\"#\x13\xE2\x84YR\x8D\x92\x0Be\x11\\\x16\xC0O>\xFC\x82\xAA\xED\xC9{\xE5\x9F?7|\r?\x01T`@Q\x90\x81R` \x90\xF3[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`2`\x04R`$_\xFD[4a\x01&W_`\x03\x196\x01\x12a\x01&W` s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF_T\x16`@Q\x90\x81R\xF3[4a\x01&W`@`\x03\x196\x01\x12a\x01&W`\x045g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x80`\x04\x01```\x03\x19\x836\x03\x01\x12a\x01&W`$5\x80\x15\x15\x80\x91\x03a\x01&WZ\x91\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0\\a\x12MW`\x01\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0]a\x14\xE3a#\x83V[a\x14\xEBa%VV[P_a\x14\xF7\x82\x80a#\xB9V[_\x91P[\x80\x82\x10a \x05WPP`D\x85\x01\x92a\x15\x13\x84\x84a$\x8DV[\x90P\x15\x15\x91a\x15!\x81a%\xC5V[\x92a\x15+\x82a%\xC5V[\x92a\x154a%>V[P`@Qa\x15A\x81a\"vV[_\x80\x82R` \x82\x01R\x82\x15a\x1F\xFEW\x83`\x01\x1C\x93[`\x1F\x19a\x15ea\x05\x1B\x87a%\xADV[\x01_[\x81\x81\x10a\x1F\xA3WPP\x83\x15a\x1F\x9BW\x94[`\x1F\x19a\x15\x9Ea\x15\x88\x88a%\xADV[\x97a\x15\x96`@Q\x99\x8Aa#\x14V[\x80\x89Ra%\xADV[\x01_[\x81\x81\x10a\x1F\x84WPP`@Q\x96a\x15\xB7\x88a\"\xF7V[\x87R` \x87\x01R_`@\x87\x01R``\x86\x01R_`\x80\x86\x01R`\xA0\x85\x01R`\xC0\x84\x01R`\xE0\x83\x01Ra\x01\0\x82\x01R\x93a\x15\xEF\x82\x80a#\xB9V[\x90P_[\x81\x81\x10a\x1A\xCBWPP`\x80\x85\x01Qa\x16\xA5W[a\x16z\x84\x7F\x10\xDDR\x8D\xB2\xC4\x9A\xDDeEg\x9B\x97m\xF9\r$\xC05\xD6\xA7[\x17\xF4\x1Bp\x0E\x8C\x18\xCASda\x05\xDD\x88a\x16M` \x82Q\x92\x01Q`@Q\x93\x84\x93`@\x85R`@\x85\x01\x90a$\xDEV[\x03\x90\xA1_\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0]Z\x90a\"iV[\x7Fo\x14\x981\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[a\x06Y\x92\x91a\x16\xBDa\x06+`$a\x16\xDD\x94\x01\x83a$\x8DV[\x94\x90\x93a\x06S``\x89\x01Q\x93\x89Q` \x81Q`\x05\x1B\x91\x01 \x926\x91a(fV[` \x81Q\x91\x01Q\x90_R` Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x80`@_ \x16\x91\x16\x90\x80\x82\x03a\x0B\x9FWPP`\xC0\x84\x01Qa\x17\xB6W[PP`@\x82\x01Q\x91a\x17,\x83aB\xF4V[\x15a\x17\x8AWa\x05\xDD\x7F\x10\xDDR\x8D\xB2\xC4\x9A\xDDeEg\x9B\x97m\xF9\r$\xC05\xD6\xA7[\x17\xF4\x1Bp\x0E\x8C\x18\xCASd\x91\x7F\n-\xC5H\xED\x95\n\xCC\xB4\r]xT\x1F9T\xC5\xE1\x82\xA8\xEC\xF1\x9EX\x1AO\"c\xF6\x1FY\xD2` a\x16z\x96`@Q\x90\x81R\xA1\x93a\x16\x06V[\x82\x7F\xDBx\x8C+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[` \x84\x01Q`\xE0\x85\x01Qa\x01\0\x86\x01Q\x90`@Q\x92a\x17\xD4\x84a\"\xDBV[\x83R` \x83\x01\x90\x80\x82R`@\x84\x01\x92\x83RQ\x92` \x93`@Qa\x17\xF7\x86\x82a#\x14V[_\x81R\x92`@Qa\x18\x08\x87\x82a#\x14V[_\x81R\x94_\x91[\x87\x84\x84\x10a\x1A_WPPPPa\x18Mc\xFF\xFF\xFF\xFF\x82\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x93\x81`\x01\x1B\x91\x80\x83\x04`\x02\x14\x90\x15\x17\x15a\t\xE2W`$\x86a\x18\x98c\xFF\xFF\xFF\xFF`(\x95\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x94Q\x94\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82`@Q\x98\x82\x82\x8B\x01\x9B`\xE0\x1B\x16\x8BR\x80Q\x91\x82\x91\x01\x86\x8B\x01^\x88\x01\x91\x7F\x91\x9E\x13\0\x1C\xD31\x9B\xE5\xA5\xA7\xCB\x18\x92\x03\xBE\x086t\xAC\xB3\xFF\xF2=\x05\xAA\xE9\xC3\xED\x861M\x85\x84\x01R`\xE0\x1B\x16\x93\x84`D\x83\x01R\x80Q\x92\x83\x91\x01`H\x83\x01^\x01\x01\x90`$\x82\x01R\x01\x84\x82Q\x91\x92\x01\x90_[\x86\x82\x82\x10a\x1AKWPPPP\x90a\x19H\x81_\x94\x93\x03`\x1F\x19\x81\x01\x83R\x82a#\x14V[`@Q\x91\x82\x91Q\x80\x91\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xADW_Q\x91`\xA0\x85\x01Q\x15a\x19wW[Pa\x17\x1BV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x80;\x15a\x01&W_\x92a\x19\xF9\x92`@Q\x95\x86\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R```\x04\x86\x01R`d\x85\x01\x91a'ZV[\x90\x7F!;?@\xD7\xC1\x13\xC1\xA0\x12\x07/\xCDy\x1F\xA4K\xF5\x16j#\0\x12\x160\xBD2(\xE2\xB0\x08'`$\x84\x01R`D\x83\x01R\x03\x91Z\xFA\x80\x15a\x02\xADWa\x1A;W[\x80\x80a\x19qV[_a\x1AE\x91a#\x14V[\x82a\x1A4V[\x83Q\x85R\x93\x84\x01\x93\x90\x92\x01\x91`\x01\x01a\x19&V[\x90\x91\x92\x96\x95a\x1Ax\x90\x82\x80a\n.a\n(\x8C\x88Qa&\x91V[\x94\x82Q\x87`\x01\x1B\x90\x88\x82\x04`\x02\x14\x89\x15\x17\x15a\t\xE2Wa\n\x85\x82a\x1A\x9B\x92a&\x91V[\x84Q\x90`\x01\x83\x01\x80\x93\x11a\t\xE2W`\x01\x93`\x04\x8C\x81\x93a\n\xB2a\n\x85\x83\x98a\x1A\xC2\x98a&\x91V[\x96\x01\x91\x90a\x18\x0FV[a\x1A\xD9\x81a\x0B\xDB\x86\x80a#\xB9V[` \x81\x01\x90a\x1A\xE8\x82\x82a#\xB9V[\x80\x91P`\x01\x1B\x81\x81\x04`\x02\x14\x82\x15\x17\x15a\t\xE2Wa\x1B\x05\x90a%\xC5V[\x90_[\x81\x81\x10a\x1F0WPP`\x01`\xFF\x82Qo\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11`\x07\x1Bg\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x82\x1C\x11`\x06\x1B\x17c\xFF\xFF\xFF\xFF\x82\x82\x1C\x11`\x05\x1B\x17a\xFF\xFF\x82\x82\x1C\x11`\x04\x1B\x17\x82\x82\x82\x1C\x11`\x03\x1B\x17`\x0F\x82\x82\x1C\x11`\x02\x1B\x17}\x01\x01\x02\x02\x02\x02\x03\x03\x03\x03\x03\x03\x03\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82\x82\x1C\x1A\x17\x90\x83\x82\x1B\x10\x01\x16\x1Ba\x1B\x9E\x81a%\xC5V[\x91_[\x82\x81\x10a\x1E\xD5WPP[`\x01\x81\x11a\x1E]WPa\x1B\xBD\x90a&\x84V[Q\x91a\x1B\xC9\x81\x83a#\xB9V[\x91\x90P_[\x82\x81\x10a\x1C\x1BWPPP`@`\x01\x93\x92a\x1C\t\x83\x7F\x1C\xC9\xA0u]\xD74\xC1\xEB\xFE\x98\xB6\x8E\xCE \x007\xE3c\xEB6m\r\xEE\x04\xE4 \xE2\xF2<\xC0\x10\x94a#\xB9V[\x83Q\x92\x83R` \x83\x01RP\xA1\x01a\x15\xF3V[a\x1C)\x81a\r1\x84\x87a#\xB9V[\x9Ba\x1C2a%VV[P\x8C``` \x82\x01\x91\x015\x80_R`\x05` R`@_ T\x15a\x0F\xE8WP`\xC0\x82\x01Q\x8E\x91\x88\x91\x15a\x1D\x18W\x83\x82a\x1C\x85a\x1C\x90\x93a\r\xA6`\xE0a\x1C\xA0\x99\x01Q`\x80\x86\x01Q`\x01\x1C\x90a\r\x966\x85a&\xB2V[`@\x86\x015\x90a)\x8CV[\x91`\xA0a\r\xE0a\r\xD5\x8A\x80a#\xB9V[\x9B``\x8D\x01\x80Q`@Q\x92a\x1C\xB4\x84a\"vV[`\xC0\x81\x015\x84R`\xE0` \x85\x01\x91\x015\x81R`@Q\x93a\x1C\xD3\x85a\"vV[_\x85R_` \x86\x01Ra\x1C\xE9\x81Q\x83Q\x90a<\x10V[\x15a\x0EaW\x91a\x1D\n\x91`\x01\x96\x95\x94\x93` \x83Q\x93\x01Q\x90Q\x91Q\x92a<rV[` \x84\x01R\x82RR\x01a\x1B\xCEV[`\xA0\x84\x01Q\x15a\x1D4W[a\x1C\xA0\x93\x82a\x1C\x85a\x1C\x90\x93a\r\xA8V[\x90Pa\x1Dws\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x92\x80a$\x8DV[` _\x81a\x1D\x88a\x0F\r6\x88a&\xB2V[`@Q\x91\x81\x83\x92Q\x91\x82\x91\x01\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xADW_Q\x93\x80;\x15a\x01&W_\x92a\x1D\xF4\x92`@Q\x96\x87\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R```\x04\x86\x01R`d\x85\x01\x91a'ZV[\x90\x7F\x91\x9E\x13\0\x1C\xD31\x9B\xE5\xA5\xA7\xCB\x18\x92\x03\xBE\x086t\xAC\xB3\xFF\xF2=\x05\xAA\xE9\xC3\xED\x861M`$\x84\x01R`D\x83\x01R\x03\x91Z\xFA\x90\x81\x15a\x02\xADW\x8F\x92\x93\x89a\x1C\x85a\x1C\x90\x93a\x1C\xA0\x97\x83\x96a\x1EMW[P\x93PPP\x93Pa\x1D#V[_a\x1EW\x91a#\x14V[_a\x1EAV[`\x01\x1C_[\x81\x81\x10a\x1EoWPa\x1B\xABV[\x80`\x01\x1B\x90\x7F\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x81\x03a\t\xE2Wa\x1E\xA7\x82\x85a&\x91V[Q\x91`\x01\x81\x01\x80\x91\x11a\t\xE2W`\x01\x92a\x10za\x1E\xC4\x92\x87a&\x91V[a\x1E\xCE\x82\x86a&\x91V[R\x01a\x1EbV[`\x01\x90\x82Q\x81\x10_\x14a\x1E\xFFWa\x1E\xEC\x81\x84a&\x91V[Qa\x1E\xF7\x82\x87a&\x91V[R[\x01a\x1B\xA1V[\x7F\xCC\x1D/\x83\x84E\xDBz\xECC\x1D\xF9\xEE\x8A\x87\x1F@\xE7\xAA^\x06O\xC0Vc>\xF8\xC6\x0F\xAB{\x06a\x1F*\x82\x87a&\x91V[Ra\x1E\xF9V[a\x1F>\x81a\r1\x87\x87a#\xB9V[\x90\x80`\x01\x1B\x81\x81\x04`\x02\x14\x82\x15\x17\x15a\t\xE2W` \x83\x015a\x1F`\x82\x87a&\x91V[R`\x01\x81\x01\x80\x91\x11a\t\xE2Wa\x1F}`\x80`\x01\x94\x015\x91\x86a&\x91V[R\x01a\x1B\x08V[` \x90a\x1F\x8Fa&-V[\x82\x82\x8B\x01\x01R\x01a\x15\xA1V[P_\x94a\x15yV[` \x90`@Qa\x1F\xB2\x81a\"\xBFV[`@Qa\x1F\xBE\x81a\"\xDBV[_\x81R_\x84\x82\x01R_`@\x82\x01R\x81R`@Qa\x1F\xDA\x81a\"vV[_\x81R_\x84\x82\x01R\x83\x82\x01R_`@\x82\x01R_``\x82\x01R\x82\x82\x8A\x01\x01R\x01a\x15hV[_\x93a\x15VV[\x90\x91a \x15\x83a\x0B\xDB\x86\x80a#\xB9V[\x90a &a\x11\xE3` \x84\x01\x84a#\xB9V[\x92\x80\x91P`\x01\x1B\x90\x80\x82\x04`\x02\x14\x90\x15\x17\x15a\t\xE2W\x80\x83\x03a\x12\x1EWP`\x01\x91a P\x91a&\xA5V[\x92\x01\x90a\x14\xFBV[4a\x01&W_`\x03\x196\x01\x12a\x01&Wa pa#7V[_s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81\x16\x83U\x16\x7F\x8B\xE0\x07\x9CS\x16Y\x14\x13D\xCD\x1F\xD0\xA4\xF2\x84\x19I\x7F\x97\"\xA3\xDA\xAF\xE3\xB4\x18okdW\xE0\x82\x80\xA3\0[4a\x01&W_`\x03\x196\x01\x12a\x01&Wa \xECa#7V[a \xF4a#\x83V[a \xFCa#\x83V[t\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF_T\x16\x17_U\x7Fb\xE7\x8C\xEA\x01\xBE\xE3 \xCDNB\x02p\xB5\xEAt\0\r\x11\xB0\xC9\xF7GT\xEB\xDB\xFCTK\x05\xA2X` `@Q3\x81R\xA1\0[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\xFF_T`\xA0\x1C\x16`@Q\x90\x15\x15\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `@Qs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\x04T`@Q\x90\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\x06T`@Q\x90\x81R\xF3[4a\x01&W` `\x03\x196\x01\x12a\x01&W` a\x13o`\x045a%\x11V[4a\x01&W_`\x03\x196\x01\x12a\x01&W\x80\x7F1.0.0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0` \x92R\xF3[\x91\x90\x82\x03\x91\x82\x11a\t\xE2WV[`@\x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a\"\x92W`@RV[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`A`\x04R`$_\xFD[`\x80\x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a\"\x92W`@RV[``\x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a\"\x92W`@RV[a\x01 \x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a\"\x92W`@RV[\x90`\x1F`\x1F\x19\x91\x01\x16\x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a\"\x92W`@RV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF_T\x163\x03a#WWV[\x7F\x11\x8C\xDA\xA7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R3`\x04R`$_\xFD[`\xFF_T`\xA0\x1C\x16a#\x91WV[\x7F\xD9<\x06e\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04_\xFD[\x905\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE1\x816\x03\x01\x82\x12\x15a\x01&W\x01\x805\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&W` \x01\x91\x81`\x05\x1B6\x03\x83\x13a\x01&WV[\x91\x90\x81\x10\x15a\x13\xEEW`\x05\x1B\x81\x015\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xC1\x816\x03\x01\x82\x12\x15a\x01&W\x01\x90V[\x91\x90\x81\x10\x15a\x13\xEEW`\x05\x1B\x81\x015\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x01\x816\x03\x01\x82\x12\x15a\x01&W\x01\x90V[\x905\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE1\x816\x03\x01\x82\x12\x15a\x01&W\x01\x805\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&W` \x01\x91\x816\x03\x83\x13a\x01&WV[\x90` \x80\x83Q\x92\x83\x81R\x01\x92\x01\x90_[\x81\x81\x10a$\xFBWPPP\x90V[\x82Q\x84R` \x93\x84\x01\x93\x90\x92\x01\x91`\x01\x01a$\xEEV[`\x04T\x81\x10\x15a\x13\xEEW`\x04_R` _ \x01\x90_\x90V[\x80T\x82\x10\x15a\x13\xEEW_R` _ \x01\x90_\x90V[`@Q\x90a%K\x82a\"vV[_` \x83\x82\x81R\x01RV[`@Q\x90a%c\x82a\"\xF7V[``a\x01\0\x83\x82\x81R\x82` \x82\x01R_`@\x82\x01R`@Qa%\x84\x81a\"vV[_\x81R_` \x82\x01R\x83\x82\x01R_`\x80\x82\x01R_`\xA0\x82\x01R_`\xC0\x82\x01R\x82`\xE0\x82\x01R\x01RV[g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\"\x92W`\x05\x1B` \x01\x90V[\x90a%\xCF\x82a%\xADV[a%\xDC`@Q\x91\x82a#\x14V[\x82\x81R`\x1F\x19a%\xEC\x82\x94a%\xADV[\x01\x90` 6\x91\x017V[\x81\x15a&\0W\x04\x90V[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x12`\x04R`$_\xFD[`@Q\x90a&:\x82a\"\xBFV[\x81_\x81R_` \x82\x01R_`@\x82\x01R```@Q\x91a&Y\x83a\"\xBFV[\x81\x83R\x81` \x84\x01R\x81`@\x84\x01R\x81\x80\x84\x01R\x01RV[\x81\x81\x02\x92\x91\x81\x15\x91\x84\x04\x14\x17\x15a\t\xE2WV[\x80Q\x15a\x13\xEEW` \x01\x90V[\x80Q\x82\x10\x15a\x13\xEEW` \x91`\x05\x1B\x01\x01\x90V[\x91\x90\x82\x01\x80\x92\x11a\t\xE2WV[\x80\x92\x91\x03\x91`\xE0\x83\x12a\x01&W`@Q\x90a&\xCC\x82a\"\xBFV[\x81\x93``\x81\x12a\x01&W\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xA0`@\x91\x82Qa'\x05\x81a\"\xDBV[\x845\x81R` \x85\x015` \x82\x01R\x83\x85\x015\x84\x82\x01R\x85R\x01\x12a\x01&W`\xC0``\x91`@Qa'4\x81a\"vV[\x83\x82\x015\x81R`\x80\x82\x015` \x82\x01R` \x85\x01R`\xA0\x81\x015`@\x85\x01R\x015\x91\x01RV[`\x1F\x82` \x94\x93`\x1F\x19\x93\x81\x86R\x86\x86\x017_\x85\x82\x86\x01\x01R\x01\x16\x01\x01\x90V[\x90a'\x94\x90`@\x93\x96\x95\x94\x96``\x84R``\x84\x01\x91a'ZV[\x94` \x82\x01R\x01RV[\x905\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x816\x03\x01\x82\x12\x15a\x01&W\x01\x90V[\x90\x82\x10\x15a\x13\xEEWa'\xE8\x91`\x05\x1B\x81\x01\x90a'\x9EV[\x90V[\x90\x92\x91\x92_[\x81\x81\x10a($W\x84\x7F\x89!\x14t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[\x84a(0\x82\x84\x86a'\xD1V[5\x14a(>W`\x01\x01a'\xF1V[\x91a'\xE8\x93\x94Pa'\xD1V[g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\"\x92W`\x1F\x01`\x1F\x19\x16` \x01\x90V[\x92\x91\x92a(r\x82a(JV[\x91a(\x80`@Q\x93\x84a#\x14V[\x82\x94\x81\x84R\x81\x83\x01\x11a\x01&W\x82\x81` \x93\x84_\x96\x017\x01\x01RV[\x90\x80`\x1F\x83\x01\x12\x15a\x01&W\x81` a'\xE8\x935\x91\x01a(fV[\x90\x80`\x1F\x83\x01\x12\x15a\x01&W\x815\x91a(\xCF\x83a%\xADV[\x92a(\xDD`@Q\x94\x85a#\x14V[\x80\x84R` \x80\x85\x01\x91`\x05\x1B\x83\x01\x01\x91\x83\x83\x11a\x01&W` \x81\x01\x91[\x83\x83\x10a)\tWPPPPP\x90V[\x825g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x82\x01\x90`@`\x1F\x19\x83\x88\x03\x01\x12a\x01&W`@Q\x90a)8\x82a\"vV[` \x83\x015`\x02\x81\x10\x15a\x01&W\x82R`@\x83\x015\x91g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x11a\x01&Wa)o\x88` \x80\x96\x95\x81\x96\x01\x01a(\x9CV[\x83\x82\x01R\x81R\x01\x92\x01\x91a(\xFAV[_\x19\x81\x14a\t\xE2W`\x01\x01\x90V[\x93\x92\x90\x91a)\x98a%VV[P\x81\x94_\x93` \x82\x015\x90\x80\x82\x03a0\xEDWP`\x80\x826\x03\x12a\x01&W`@Q\x93a)\xC2\x85a\"\xBFV[\x825\x94\x85\x81R\x82` \x82\x01R`@\x84\x01\x94\x855g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x85\x01\x90`\x80\x826\x03\x12a\x01&W`@Q\x91a)\xFE\x83a\"\xBFV[\x805g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa*\x1C\x906\x90\x83\x01a(\xB7V[\x83R` \x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa*?\x906\x90\x83\x01a(\xB7V[` \x84\x01R`@\x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa*e\x906\x90\x83\x01a(\xB7V[`@\x84\x01R``\x81\x015\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&Wa*\x8B\x916\x91\x01a(\xB7V[``\x83\x01R`@\x83\x01\x91\x82R``\x86\x01\x92\x835g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa*\xBA\x906\x90\x89\x01a(\x9CV[``\x82\x01Ra*\xC7a&-V[PQ\x91Q\x90`@Q\x92a*\xD9\x84a\"\xBFV[\x83R`\x01` \x84\x01R`@\x83\x01R``\x82\x01R`\xC0\x83\x01Q\x15a/\xFBWa+\x11\x91Pa\x01\0\x83\x01Q`\x80\x84\x01Q\x91a\r\xA0\x83\x83a&\x91V[P[a+*a+ \x85\x85a'\x9EV[`@\x81\x01\x90a#\xB9V[\x90P\x86[\x81\x81\x10a-\xF5WPP\x80` a+g\x92Q\x91\x87a+Q`\x80\x83\x01\x94\x85Q\x90a&\x91V[R\x01Q\x81Q\x91a+`\x83a)~V[\x90Ra&\x91V[Ra+q\x83aC-V[\x15a-\xC9Wa+\x89a+\x83\x83\x83a'\x9EV[\x80a#\xB9V[\x85[\x81\x81\x10a-ZWPPPa+\xACa+\xA2\x83\x83a'\x9EV[` \x81\x01\x90a#\xB9V[\x85[\x81\x81\x10a,\xEBWPPPa+\xC5a+ \x83\x83a'\x9EV[\x85[\x81\x81\x10a,xWPPPa+\xE8\x91a+\xDE\x91a'\x9EV[``\x81\x01\x90a#\xB9V[\x83\x92\x91\x92[\x81\x81\x10a+\xFBWPPPPPV[a,\x06\x81\x83\x86a$\rV[5`\x02\x81\x10\x15a,tW\x90`\x01\x80\x92\x14a,!W[\x01a+\xEDV[\x83\x7F\xA4\x94\xDA\xC4\xB7\x18HCX?\x97.\x06x>,;\xB4\x7FO\x017\xB8\xDFR\xA8`\xDF\x07!\x9F\x8Ca,[a,Q\x84\x87\x8Aa$\rV[` \x81\x01\x90a$\x8DV[\x90a,l`@Q\x92\x83\x92\x87\x84a;\xF9V[\x03\x90\xA2a,\x1BV[\x85\x80\xFD[a,\x83\x81\x83\x85a$\rV[5`\x02\x81\x10\x15a,\xE7W\x90`\x01\x80\x92\x14a,\x9EW[\x01a+\xC7V[\x86\x7F\x9Ca\xB2\x90\xF61\t\x7FV'<\xF4\xDA\xF4\r\xF1\xFF\x9C\xCC3\xF1\x01\xD4d\x83}\xA1\xF5\xAE\x18\xBDYa,\xCEa,Q\x84\x87\x89a$\rV[\x90a,\xDF`@Q\x92\x83\x92\x87\x84a;\xF9V[\x03\x90\xA2a,\x98V[\x87\x80\xFD[a,\xF6\x81\x83\x85a$\rV[5`\x02\x81\x10\x15a,\xE7W\x90`\x01\x80\x92\x14a-\x11W[\x01a+\xAEV[\x86\x7FH$8s\xB4u-\xDC\xB4^\r{\x11\xC4\xC2fX>^\t\x9A\x0By\x8F\xDD\x9C\x1A\xF7\xD4\x93$\xF3a-Aa,Q\x84\x87\x89a$\rV[\x90a-R`@Q\x92\x83\x92\x87\x84a;\xF9V[\x03\x90\xA2a-\x0BV[a-e\x81\x83\x85a$\rV[5`\x02\x81\x10\x15a,\xE7W\x90`\x01\x80\x92\x14a-\x80W[\x01a+\x8BV[\x86\x7F:\x13M\x01\xC0x\x03\0<c0\x17\x17\xDD\xC4a.lG\xAE@\x8E\xEE\xA3\",\xDE\xD52\xD0*\xE6a-\xB0a,Q\x84\x87\x89a$\rV[\x90a-\xC1`@Q\x92\x83\x92\x87\x84a;\xF9V[\x03\x90\xA2a-zV[`$\x84\x84\x7F9\xA9@\xC5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82R`\x04R\xFD[a.\ta,Q\x82a\x0B\xDBa+ \x8A\x8Aa'\x9EV[\x81\x01\x90``\x81\x83\x03\x12a/\xF7W\x805\x91s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x80\x93\x03a/\xF3W` \x82\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a/\xEFW\x81a.W\x91\x84\x01a(\x9CV[\x91`@\x81\x015\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a/\xE0Wa.x\x92\x91\x01a(\x9CV[\x90`@Q\x91\x7F3\xA8\x92\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83R\x87`\x04\x84\x01R`@`$\x84\x01R\x8B\x83\x80a.\xBD`D\x82\x01\x86a@\0V[\x03\x81\x83\x88Z\xF1\x92\x83\x15a/\xE4W\x8C\x93a/`W[P\x82Q` \x84\x01 \x81Q` \x83\x01 \x03a/%WP`\x01\x93\x92\x91\x7F\xCD\xDB2z\xDB1\xFET7\xDF*\x8Ch0\x1B\xB1:k\xAA\xE42\xA8\x04\x83\x8C\xAA\xF6\x82Pj\xAD\xF1\x91a/\x1C`@Q\x92\x83\x92\x83a@%V[\x03\x90\xA2\x01a+.V[\x90Pa/\\`@Q\x92\x83\x92\x7F\xC5\x04\xFA\xDA\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x84R`\x04\x84\x01a@%V[\x03\x90\xFD[\x90\x92P=\x80\x8D\x83>a/r\x81\x83a#\x14V[\x81\x01\x90` \x81\x83\x03\x12a/\xE0W\x80Q\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a/\xDCW\x01\x81`\x1F\x82\x01\x12\x15a/\xE0W\x80Q\x90a/\xA9\x82a(JV[\x92a/\xB7`@Q\x94\x85a#\x14V[\x82\x84R` \x83\x83\x01\x01\x11a/\xDCW\x81\x8E\x92` \x80\x93\x01\x83\x86\x01^\x83\x01\x01R\x91_a.\xD1V[\x8D\x80\xFD[\x8C\x80\xFD[`@Q=\x8E\x82>=\x90\xFD[\x8B\x80\xFD[\x8A\x80\xFD[\x89\x80\xFD[`\xA0\x83\x01Q\x15a0\rW[PPa+\x13V[a0^\x90` _\x81a0Vs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x96\x8Aa$\x8DV[\x95\x90\x94a9\x83V[`@Q\x91\x81\x83\x92Q\x91\x82\x91\x01\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xADW_Q\x92\x80;\x15a\x01&W_\x92\x86\x92a0\xC3`@Q\x96\x87\x95\x86\x94\x85\x94\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x86R`\x04\x86\x01a'zV[\x03\x91Z\xFA\x80\x15a\x02\xADWa0\xD8W[\x80a0\x06V[a0\xE5\x91\x96P_\x90a#\x14V[_\x94_a0\xD2V[\x7F\x18\xF69\xD8\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$R`D_\xFD[\x93\x92\x90\x91_\x94a1)a%VV[P\x82\x95` \x82\x015\x94\x80\x86\x03a8\xF5WP`\x80\x826\x03\x12a\x01&W`@Q\x94a1Q\x86a\"\xBFV[\x825\x95\x86\x81R\x81` \x82\x01R`@\x84\x01\x94\x855g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x85\x01\x90`\x80\x826\x03\x12a\x01&W`@Q\x91a1\x8D\x83a\"\xBFV[\x805g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa1\xAB\x906\x90\x83\x01a(\xB7V[\x83R` \x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa1\xCE\x906\x90\x83\x01a(\xB7V[` \x84\x01R`@\x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa1\xF4\x906\x90\x83\x01a(\xB7V[`@\x84\x01R``\x81\x015\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&Wa2\x1A\x916\x91\x01a(\xB7V[``\x83\x01R`@\x83\x01\x91\x82R``\x86\x01\x92\x835g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa2I\x906\x90\x89\x01a(\x9CV[``\x82\x01Ra2Va&-V[PQ\x91Q\x90`@Q\x92a2h\x84a\"\xBFV[\x83R_` \x84\x01R`@\x83\x01R``\x82\x01R`\xC0\x87\x01Q\x15a8\x0BWa2\x9F\x91Pa\x01\0\x87\x01Q`\x80\x88\x01Q\x91a\r\xA0\x83\x83a&\x91V[P[a2\xAEa+ \x85\x85a'\x9EV[\x90P\x82[\x81\x81\x10a6PWPPa2\xE3\x85Q\x87a2\xD1`\x80\x89\x01\x92\x83Q\x90a&\x91V[R` \x87\x01Q\x81Q\x91a+`\x83a)~V[R\x92`\xFF`\x02T\x16\x90`\x01Ta2\xF8\x81a)~V[`\x01U\x91\x86\x92_[\x82\x81\x10a5\xAAWPP`\x01T`\x01`\xFF`\x02T\x16\x1B\x14a5QW[P`@\x01Ra3-a+\x83\x83\x83a'\x9EV[\x90\x84[\x82\x81\x10a4\xE2WPPPa3Ga+\xA2\x83\x83a'\x9EV[\x90\x84[\x82\x81\x10a4sWPPPa3aa+ \x83\x83a'\x9EV[\x90\x84[\x82\x81\x10a4\0WPPPa3{\x91a+\xDE\x91a'\x9EV[\x92\x90\x82[\x84\x81\x10a3\x8DWPPPPPV[a3\x98\x81\x86\x84a$\rV[5`\x02\x81\x10\x15a3\xFCW\x90`\x01\x80\x92\x14a3\xB3W[\x01a3\x7FV[\x83\x7F\xA4\x94\xDA\xC4\xB7\x18HCX?\x97.\x06x>,;\xB4\x7FO\x017\xB8\xDFR\xA8`\xDF\x07!\x9F\x8Ca3\xE3a,Q\x84\x8A\x88a$\rV[\x90a3\xF4`@Q\x92\x83\x92\x87\x84a;\xF9V[\x03\x90\xA2a3\xADV[\x84\x80\xFD[a4\x0B\x81\x84\x84a$\rV[5`\x02\x81\x10\x15a4oW\x90`\x01\x80\x92\x14a4&W[\x01a3dV[\x87\x7F\x9Ca\xB2\x90\xF61\t\x7FV'<\xF4\xDA\xF4\r\xF1\xFF\x9C\xCC3\xF1\x01\xD4d\x83}\xA1\xF5\xAE\x18\xBDYa4Va,Q\x84\x88\x88a$\rV[\x90a4g`@Q\x92\x83\x92\x87\x84a;\xF9V[\x03\x90\xA2a4 V[\x86\x80\xFD[a4~\x81\x84\x84a$\rV[5`\x02\x81\x10\x15a4oW\x90`\x01\x80\x92\x14a4\x99W[\x01a3JV[\x87\x7FH$8s\xB4u-\xDC\xB4^\r{\x11\xC4\xC2fX>^\t\x9A\x0By\x8F\xDD\x9C\x1A\xF7\xD4\x93$\xF3a4\xC9a,Q\x84\x88\x88a$\rV[\x90a4\xDA`@Q\x92\x83\x92\x87\x84a;\xF9V[\x03\x90\xA2a4\x93V[a4\xED\x81\x84\x84a$\rV[5`\x02\x81\x10\x15a4oW\x90`\x01\x80\x92\x14a5\x08W[\x01a30V[\x87\x7F:\x13M\x01\xC0x\x03\0<c0\x17\x17\xDD\xC4a.lG\xAE@\x8E\xEE\xA3\",\xDE\xD52\xD0*\xE6a58a,Q\x84\x88\x88a$\rV[\x90a5I`@Q\x92\x83\x92\x87\x84a;\xF9V[\x03\x90\xA2a5\x02V[\x90\x91`\x02T\x90h\x01\0\0\0\0\0\0\0\0\x82\x10\x15a\"\x92W`@\x92a5\x80\x83`\x01a5\xA3\x95\x01`\x02U`\x02a%)V[\x81T\x90`\x03\x1B\x90_\x19\x85\x83\x1B\x92\x1B\x19\x16\x17\x90U`\x03_R` _ \x01T\x90a>IV[\x91\x90a3\x1BV[\x90\x93`\x01\x90\x81\x86\x16a6\x18W\x7F@W\x87\xFA\x12\xA8#\xE0\xF2\xB7c\x1C\xC4\x1B;\xA8\x82\x8B3!\xCA\x81\x11\x11\xFAu\xCD:\xA3\xBBZ\xCE\x83\x01\x81\x90U`\x03_R\x7F\xC2WZ\x0E\x9EY<\0\xF9Y\xF8\xC9/\x12\xDB(i\xC39Z;\x05\x02\xD0^%\x16Doq\xF8[\x83\x01Ta6\r\x91a>IV[\x94[\x81\x1C\x91\x01a3\0V[`\x02_R\x7F@W\x87\xFA\x12\xA8#\xE0\xF2\xB7c\x1C\xC4\x1B;\xA8\x82\x8B3!\xCA\x81\x11\x11\xFAu\xCD:\xA3\xBBZ\xCE\x83\x01Ta6J\x91\x90a>IV[\x94a6\x0FV[a6da,Q\x82a\x0B\xDBa+ \x8A\x8Aa'\x9EV[\x81\x01\x90``\x81\x83\x03\x12a,tW\x805\x91s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x80\x93\x03a4oW` \x82\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a,\xE7W\x81a6\xB2\x91\x84\x01a(\x9CV[\x91`@\x81\x015\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a7\xFCWa6\xD3\x92\x91\x01a(\x9CV[\x90`@Q\x91\x7F3\xA8\x92\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83R\x86`\x04\x84\x01R`@`$\x84\x01R\x87\x83\x80a7\x18`D\x82\x01\x86a@\0V[\x03\x81\x83\x88Z\xF1\x92\x83\x15a8\0W\x88\x93a7\x80W[P\x82Q` \x84\x01 \x81Q` \x83\x01 \x03a/%WP`\x01\x93\x92\x91\x7F\xCD\xDB2z\xDB1\xFET7\xDF*\x8Ch0\x1B\xB1:k\xAA\xE42\xA8\x04\x83\x8C\xAA\xF6\x82Pj\xAD\xF1\x91a7w`@Q\x92\x83\x92\x83a@%V[\x03\x90\xA2\x01a2\xB2V[\x90\x92P=\x80\x89\x83>a7\x92\x81\x83a#\x14V[\x81\x01\x90` \x81\x83\x03\x12a7\xFCW\x80Q\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a/\xF7W\x01\x81`\x1F\x82\x01\x12\x15a7\xFCW\x80Q\x90a7\xC9\x82a(JV[\x92a7\xD7`@Q\x94\x85a#\x14V[\x82\x84R` \x83\x83\x01\x01\x11a/\xF7W\x81\x8A\x92` \x80\x93\x01\x83\x86\x01^\x83\x01\x01R\x91_a7,V[\x88\x80\xFD[`@Q=\x8A\x82>=\x90\xFD[`\xA0\x87\x01Q\x15a8\x1DW[PPa2\xA1V[a8f\x90` _\x81a0Vs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x96\x8Aa$\x8DV[`@Q\x91\x81\x83\x92Q\x91\x82\x91\x01\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xADW_Q\x92\x80;\x15a\x01&W_\x92\x85\x92a8\xCB`@Q\x96\x87\x95\x86\x94\x85\x94\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x86R`\x04\x86\x01a'zV[\x03\x91Z\xFA\x80\x15a\x02\xADWa8\xE0W[\x80a8\x16V[a8\xED\x91\x92P_\x90a#\x14V[_\x90_a8\xDAV[\x85\x90\x7F\x18\xF69\xD8\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$R`D_\xFD[\x80Q\x80Q\x91`@` \x83\x01Q\x92\x01Q` \x82\x01Q` \x81Q\x91\x01Q\x91```@\x85\x01Q\x94\x01Q\x94`@Q\x96` \x88\x01R`@\x87\x01R``\x86\x01R`\x80\x85\x01R`\xA0\x84\x01R`\xC0\x83\x01R`\xE0\x82\x01R`\xE0\x81Ra'\xE8a\x01\0\x82a#\x14V[``\x81\x01Q\x81Q` \x83\x01Q\x90\x91\x90\x15a;\xF0W`@c\x01\0\0\0\x93[\x01Q\x90\x80Q\x90\x81Qc\xFF\xFF\xFF\xFF\x16a9\xDA\x90b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x91a9\xE4\x90a>\x8CV[` \x82\x01Q\x80Qc\xFF\xFF\xFF\xFF\x16a:\x1D\x90b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x90a:'\x90a>\x8CV[\x90`@\x84\x01Q\x92\x83Qc\xFF\xFF\xFF\xFF\x16a:b\x90b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x93a:l\x90a>\x8CV[\x94``\x01Q\x95\x86Qc\xFF\xFF\xFF\xFF\x16a:\xA6\x90b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x96a:\xB0\x90a>\x8CV[\x97`@Q\x9A\x8B\x9A` \x8C\x01R`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`@\x8B\x01R`D\x8A\x01R`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`d\x89\x01R\x80Q` \x81\x92\x01`h\x8A\x01^\x87\x01\x90`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`h\x82\x01R\x81Q` \x81\x93\x01`l\x83\x01^\x01`h\x01\x90`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`\x04\x82\x01R\x81Q` \x81\x93\x01`\x08\x83\x01^\x01`\x04\x01\x90`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`\x04\x82\x01R\x81Q` \x81\x93\x01`\x08\x83\x01^\x01`\x04\x01`\x04\x81\x01_\x90R\x03`\x04\x01`\x1F\x19\x81\x01\x82Ra'\xE8\x90\x82a#\x14V[`@_\x93a9\xA0V[`@\x90a'\xE8\x94\x92\x81R\x81` \x82\x01R\x01\x91a'ZV[\x80\x15\x80\x15a<bW[\x80\x15a<ZW[\x80\x15a<JW[a<DWd\x01\0\0\x03\xD0\x19`\x07\x81\x80\x93\x81\x81\x80\t\t\x08\x91\x80\t\x14\x90V[PP_\x90V[Pd\x01\0\0\x03\xD0\x19\x82\x10\x15a<'V[P\x81\x15a< V[Pd\x01\0\0\x03\xD0\x19\x81\x10\x15a<\x19V[\x92\x93\x92\x90\x91_\x90\x80\x83\x03a>,WPPd\x01\0\0\x03\xD0\x19_\x94\x83\x08a<\x9BWPP\x90P_\x90_\x90V[_a<\xAD\x92d\x01\0\0\x03\xD0\x19\x92aB}V[\x93\x90\x91\x90[\x84\x15\x15\x85\x81a>\x1BW[P\x80a>\x13W[\x15a=\xB5W\x80\x94\x80`\x01d\x01\0\0\x03\xD0\x19\x84\x92[a=+WPPPP\x80a<\xFEWP\x90d\x01\0\0\x03\xD0\x19\x80\x92\x81\x80\x87\x80\t\x80\x92\t\x95\t\x90\t\x90V[\x80\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`$\x92R`\x12`\x04R\xFD[a=9\x84\x82\x9A\x94\x95\x9Aa%\xF6V[\x91\x80\x94a=\x88Wd\x01\0\0\x03\xD0\x19\x90\x83\td\x01\0\0\x03\xD0\x19\x03\x90d\x01\0\0\x03\xD0\x19\x82\x11a\t\xE2Wa=zd\x01\0\0\x03\xD0\x19a=\x80\x93\x88\x96\x08\x95\x9A\x80\x94a&qV[\x90a\"iV[\x92\x90\x83a<\xD7V[`$\x86\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x12`\x04R\xFD[`d`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x0E`$\x82\x01R\x7FInvalid number\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R\xFD[P`\x01a<\xC3V[d\x01\0\0\x03\xD0\x19\x91P\x14\x15_a<\xBCV[a>@\x93d\x01\0\0\x03\xD0\x19\x93\x96\x92\x96a@\x82V[\x93\x90\x91\x90a<\xB2V[_\x90` \x92`@Q\x90\x84\x82\x01\x92\x83R`@\x82\x01R`@\x81Ra>l``\x82a#\x14V[`@Q\x91\x82\x91Q\x80\x91\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xADW_Q\x90V[\x80Q``\x92\x91_\x91[\x80\x83\x10a>\xA1WPPPV[\x90\x91\x93a>\xE8c\xFF\xFF\xFF\xFF` a>\xB8\x88\x87a&\x91V[Q\x01QQ`\x02\x1C\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x90` a>\xF5\x87\x86a&\x91V[Q\x01Qa?\x02\x87\x86a&\x91V[QQ`\x02\x81\x10\x15a?\xD3W`\x04` \x93a?\xCA\x93\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x86\x80`\x01\x99a?i\x87\x98b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x94\x84`@Q\x9B\x88\x8D\x99Q\x91\x82\x91\x01\x86\x8B\x01^\x88\x01\x92`\xE0\x1B\x16\x83\x83\x01R\x80Q\x92\x83\x91\x01`$\x83\x01^\x01\x01\x91`\xE0\x1B\x16\x83\x82\x01R\x03\x01\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE4\x81\x01\x84R\x01\x82a#\x14V[\x94\x01\x91\x90a>\x95V[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`!`\x04R`$_\xFD[\x90`\x1F\x19`\x1F` \x80\x94\x80Q\x91\x82\x91\x82\x87R\x01\x86\x86\x01^_\x85\x82\x86\x01\x01R\x01\x16\x01\x01\x90V[\x90\x91a@<a'\xE8\x93`@\x84R`@\x84\x01\x90a@\0V[\x91` \x81\x84\x03\x91\x01Ra@\0V[\x80Th\x01\0\0\0\0\0\0\0\0\x81\x10\x15a\"\x92Wa@l\x91`\x01\x82\x01\x81Ua%)V[_\x19\x82\x93\x92T\x91`\x03\x1B\x92\x83\x1B\x92\x1B\x19\x16\x17\x90UV[\x94\x92\x91\x85\x15\x80aBuW[aBiW\x80\x15\x80aBaW[aBWW`@Q`\x80\x91a@\xAD\x83\x83a#\x14V[\x826\x837\x86\x15a&\0W\x86\x94\x85\x80\x92\x81\x80`\x01\x80\t\x80\x87R\x97\x81\x89`\x01\t\x9C` \x88\x01\x9D\x8ER\x82`@\x89\x01\x9D\x8E\x8C\x81RQ`\x01\t\x91``\x8A\x01\x92\x83R`@Q\x9E\x8Fa@\xF7\x90a\"\xBFV[Q\x90\t\x8DRQ\x90\t\x94` \x8B\x01\x95\x86RQ\x90\t\x98`@\x89\x01\x99\x8ARQ\x90\t``\x87\x01\x90\x81R\x86Q\x88Q\x14\x80\x15\x90aBKW[\x15aA\xEDW\x84\x92\x83\x80\x80\x93\x81`@Q\x9C\x85aAE\x8F\x97\x88a#\x14V[6\x877Q\x8CQaAU\x90\x83a\"iV[\x90\x08\x84RQ\x85QaAf\x90\x83a\"iV[\x90\x08\x98` \x83\x01\x99\x8AR\x81\x80\x8B\x81\x80\x80\x80\x89Q\x8AQ\x90\t\x93`@\x8A\x01\x94\x85R\x81\x85Q\x8BQ\x90\t``\x90\x9A\x01\x99\x8ARQ\x80\t\x88QaA\xA3\x90\x83a\"iV[\x90\x08\x81\x80\x87Q\x85Q\x90\t`\x02\taA\xBA\x90\x83a\"iV[\x90\x08\x9CQ\x93Q\x90Q\x90\taA\xCE\x8C\x83a\"iV[\x90\x08\x90\t\x92Q\x90Q\x90\taA\xE2\x90\x83a\"iV[\x90\x08\x94Q\t\x91\x92\x91\x90V[`d`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x1E`$\x82\x01R\x7FUse jacDouble function instead\0\0`D\x82\x01R\xFD[P\x81Q\x81Q\x14\x15aA)V[P\x92P`\x01\x91\x90PV[P\x82\x15a@\x99V[\x94P\x90\x92P`\x01\x91\x90PV[P\x81\x15a@\x8DV[\x93\x91\x92\x90\x92\x81\x15a&\0W`\x01\x82\x80aB\xEA\x81\x80\x80\x80\x97\x81\x80aB\xDA\x9E\x81\x8F\x81\x81\x81\x92\t\x9A\x8B\x96\x81\x8F\x81\x80\x82\x81\x93\t\x9A\x88\t`\x04\t\x98\x80\t\x90\t\x92\x80\t`\x03\t\x08\x91\x81aB\xCD\x81\x83\x80\x08\x82a\"iV[\x81\x85\x80\t\x08\x9E\x8F\x83a\"iV[\x90\x08\x90\t\x93\x80\t`\x08\t\x83a\"iV[\x90\x08\x94\t`\x02\t\x90V[\x80_R`\x05` R`@_ T\x15_\x14aC(WaC\x13\x81`\x04a@JV[`\x04T\x90_R`\x05` R`@_ U`\x01\x90V[P_\x90V[\x80_R`\x07` R`@_ T\x15_\x14aC(WaCL\x81`\x06a@JV[`\x06T\x90_R`\x07` R`@_ U`\x01\x90V[`\x04\x11\x15a?\xD3WV[\x81Q\x91\x90`A\x83\x03aC\x9BWaC\x94\x92P` \x82\x01Q\x90```@\x84\x01Q\x93\x01Q_\x1A\x90aDlV[\x91\x92\x90\x91\x90V[PP_\x91`\x02\x91\x90V[aC\xAE\x81aCaV[\x80aC\xB7WPPV[aC\xC0\x81aCaV[`\x01\x81\x03aC\xF0W\x7F\xF6E\xEE\xDF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04_\xFD[aC\xF9\x81aCaV[`\x02\x81\x03aD-WP\x7F\xFC\xE6\x98\xF7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[`\x03\x90aD9\x81aCaV[\x14aDAWPV[\x7F\xD7\x8B\xCE\x0C\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[\x91\x90\x7F\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF]WnsW\xA4P\x1D\xDF\xE9/Fh\x1B \xA0\x84\x11aD\xF0W\x91` \x93`\x80\x92`\xFF_\x95`@Q\x94\x85R\x16\x86\x84\x01R`@\x83\x01R``\x82\x01R\x82\x80R`\x01Z\xFA\x15a\x02\xADW_Qs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x15aD\xE6W\x90_\x90_\x90V[P_\x90`\x01\x90_\x90V[PPP_\x91`\x03\x91\x90V\xFC\xED\xD3u\x89\x8C\0\xDER\xE8\xF1;\x0B\x8E2\xAD\x9C\x15w\xFE3;\x1D\x8F\x9C\x93*\xE1\xBC\xA6\xDA\xC3\xCC\x1D/\x83\x84E\xDBz\xECC\x1D\xF9\xEE\x8A\x87\x1F@\xE7\xAA^\x06O\xC0Vc>\xF8\xC6\x0F\xAB{\x06",
    );
    /// The runtime bytecode of the contract, as deployed on the network.
    ///
    /// ```text
    ///0x6080806040526004361015610012575f80fd5b5f3560e01c9081630d8e6e2c146122315750806331ee62421461221357806340f34d42146121f657806359ba9258146121d95780635b666b1e146121895780635c975abb1461216557806363a599a4146120d4578063715018a61461205857806382d32ad81461144d5780638da5cb5b1461141b5780639ad91d4c1461139e578063a06056f71461137e578063bdeb442d14611346578063c1b0bed71461131a578063c44956d1146112fd578063c879dbe4146112d1578063e33845cf14611275578063ed3cf91f146103d9578063f2fde38b14610308578063fddd48371461012a5763fe18ab9114610103575f80fd5b34610126575f600319360112610126576020600160ff600254161b604051908152f35b5f80fd5b34610126575f600319360112610126576040517f3cadf4490000000000000000000000000000000000000000000000000000000081527fffffffff000000000000000000000000000000000000000000000000000000007f000000000000000000000000000000000000000000000000000000000000000016600482015260208160248173ffffffffffffffffffffffffffffffffffffffff7f0000000000000000000000000000000000000000000000000000000000000000165afa9081156102ad575f916102b8575b50602073ffffffffffffffffffffffffffffffffffffffff916004604051809481937f5c975abb000000000000000000000000000000000000000000000000000000008352165afa80156102ad575f90610271575b6020915060ff5f5460a01c16908115610269575b506040519015158152f35b90508261025e565b506020813d6020116102a5575b8161028b60209383612314565b81010312610126575180151581036101265760209061024a565b3d915061027e565b6040513d5f823e3d90fd5b90506020813d602011610300575b816102d360209383612314565b81010312610126575173ffffffffffffffffffffffffffffffffffffffff811681036101265760206101f5565b3d91506102c6565b346101265760206003193601126101265760043573ffffffffffffffffffffffffffffffffffffffff811680910361012657610342612337565b80156103ad5773ffffffffffffffffffffffffffffffffffffffff5f54827fffffffffffffffffffffffff00000000000000000000000000000000000000008216175f55167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e05f80a3005b7f1e4fbdf7000000000000000000000000000000000000000000000000000000005f525f60045260245ffd5b346101265760206003193601126101265760043567ffffffffffffffff8111610126578060040160606003198336030112610126577f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005c61124d5760017f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005d610460612383565b610468612556565b505f9061047581806123b9565b5f91505b8082106111c25750506044830191610491838361248d565b9050151561049e826125c5565b916104a8816125c5565b916104b161253e565b506040516104be81612276565b5f808252602082015281156111bb578260011c925b601f196104f86104e2866125ad565b956104f06040519788612314565b8087526125ad565b015f5b818110611160575050821561115857935b601f1961053161051b876125ad565b966105296040519889612314565b8088526125ad565b015f5b8181106111415750506040519561054a876122f7565b865260208601525f604086015260608501525f60808501525f60a085015260c084015260e08301526101008201529261058382806123b9565b90505f5b818110610bcd5750506080840151610613575b7f10dd528db2c49add6545679b976df90d24c035d6a75b17f41b700e8c18ca53646105dd856105eb602082519201516040519384936040855260408501906124de565b9083820360208501526124de565b0390a15f7f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005d005b610659929161063361062b602461066294018361248d565b94909261248d565b94909361065360608801519388516020815160051b910120923691612866565b9061436b565b909391936143a5565b60208151910151905f5260205273ffffffffffffffffffffffffffffffffffffffff8060405f2016911690808203610b9f57505060c0830151610739575b50506040810151906106b1826142f4565b1561070d576105dd907f0a2dc548ed950accb40d5d78541f3954c5e182a8ecf19e581a4f2263f61f59d260207f10dd528db2c49add6545679b976df90d24c035d6a75b17f41b700e8c18ca536494604051908152a1918361059a565b507fdb788c2b000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b602083015160e08401516101008501519060405192610757846122db565b8352602083019080825260408401928352519260209360405161077a8682612314565b5f81529260405161078b8782612314565b5f8152945f915b87848410610a0f57505050506107d063ffffffff821662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b938160011b91808304600214901517156109e25760248661081b63ffffffff6028951662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b9451947fffffffff00000000000000000000000000000000000000000000000000000000826040519882828b019b60e01b168b52805191829101868b015e8801917f919e13001cd3319be5a5a7cb189203be083674acb3fff23d05aae9c3ed86314d8584015260e01b1693846044830152805192839101604883015e010190602482015201848251919201905f5b868282106109ce5750505050906108cb815f949303601f198101835282612314565b604051918291518091835e8101838152039060025afa156102ad575f519160a0840151156108fa575b506106a0565b73ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016803b15610126575f9261097c92604051958694859384937fab750e7500000000000000000000000000000000000000000000000000000000855260606004860152606485019161275a565b907f213b3f40d7c113c1a012072fcd791fa44bf5166a2300121630bd3228e2b008276024840152604483015203915afa80156102ad576109be575b80806108f4565b5f6109c891612314565b816109b7565b8351855293840193909201916001016108a9565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52601160045260245ffd5b9091929695610a62908280610a2e610a288c8851612691565b51613925565b6040519584879551918291018487015e8401908282015f8152815193849201905e01015f815203601f198101835282612314565b9482518760011b90888204600214891517156109e257610a8582610a8b92612691565b51613983565b845190600183018093116109e25760019360048c8193610ab2610a858398610b9698612691565b7fffffffff000000000000000000000000000000000000000000000000000000008380610b0b63ffffffff865160021c1662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b610b4163ffffffff865160021c1662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b95846040519d8b8f82819e519384930191015e8b019260e01b1683830152805192839101602483015e01019260e01b1684830152805192839101600883015e01015f838201520301601f198101835282612314565b96019190610792565b7fe6d44b4c000000000000000000000000000000000000000000000000000000005f5260045260245260445ffd5b610be181610bdb86806123b9565b9061240d565b6020810190610bf082826123b9565b80915060011b818104600214821517156109e257610c0d906125c5565b905f5b8181106110ed575050600160ff82516fffffffffffffffffffffffffffffffff811160071b67ffffffffffffffff82821c1160061b1763ffffffff82821c1160051b1761ffff82821c1160041b178282821c1160031b17600f82821c1160021b177d01010202020203030303030303030000000000000000000000000000000082821c1a179083821b1001161b610ca6816125c5565b915f5b8281106110925750505b600181116110135750610cc590612684565b5191610cd181836123b9565b9190505f5b828110610d2357505050604060019392610d11837f1cc9a0755dd734c1ebfe98b68ece200037e363eb366d0dee04e420e2f23cc010946123b9565b8351928352602083015250a101610587565b610d3781610d3184876123b9565b9061244d565b9a610d40612556565b5060208c0160608d0135805f52600560205260405f205415610fe8575060c08201518792918e9115610e99579282916040610dbb610de996610da660e0610dc4980151608088015160011c90610d9636856126b2565b610da08383612691565b52612691565b505b610db28c806123b9565b909135916127eb565b9101359061298c565b868d60a0610de0610dd58a806123b9565b6080850135916127eb565b9101359061311b565b9a60608c01805160405192610dfd84612276565b60c0810135845260e060208501910135815260405193610e1c85612276565b5f85525f6020860152610e328151835190613c10565b15610e615791610e5391600196959493602083519301519051915192613c72565b602084015282525201610cd6565b604491604051917fb8a0e8a1000000000000000000000000000000000000000000000000000000008352516004830152516024820152fd5b60a083015115610eb8575b92610dc492916040610dbb610de996610da8565b925090610efc73ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016928061248d565b60205f81610f12610f0d368a6126b2565b613925565b604051918183925191829101835e8101838152039060025afa156102ad575f5193803b15610126575f92610f7e92604051968794859384937fab750e7500000000000000000000000000000000000000000000000000000000855260606004860152606485019161275a565b907f919e13001cd3319be5a5a7cb189203be083674acb3fff23d05aae9c3ed86314d6024840152604483015203915afa9283156102ad578e6040610dbb8b93610dc496610de998610fd8575b509396505050919250610ea4565b5f610fe291612314565b5f610fca565b7ff9849ea3000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b60011c5f5b8181106110255750610cb3565b8060011b907f7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff811681036109e25761105d8285612691565b5191600181018091116109e25760019261107a6110819287612691565b5190613e49565b61108b8286612691565b5201611018565b600190825181105f146110bc576110a98184612691565b516110b48287612691565b525b01610ca9565b7fcc1d2f838445db7aec431df9ee8a871f40e7aa5e064fc056633ef8c60fab7b066110e78287612691565b526110b6565b6110fb81610d3187876123b9565b908060011b818104600214821517156109e257602083013561111d8287612691565b52600181018091116109e25761113a608060019401359186612691565b5201610c10565b60209061114c61262d565b82828a01015201610534565b505f9361050c565b60209060405161116f816122bf565b60405161117b816122db565b5f81525f848201525f6040820152815260405161119781612276565b5f81525f84820152838201525f60408201525f6060820152828289010152016104fb565b5f926104d3565b90926111d284610bdb85806123b9565b906111ec6111e360208401846123b9565b938091506123b9565b9280915060011b90808204600214901517156109e25780830361121e5750600191611216916126a5565b930190610479565b827fd3bee78d000000000000000000000000000000000000000000000000000000005f5260045260245260445ffd5b7f3ee5aeb5000000000000000000000000000000000000000000000000000000005f5260045ffd5b34610126575f6003193601126101265760206040517fffffffff000000000000000000000000000000000000000000000000000000007f0000000000000000000000000000000000000000000000000000000000000000168152f35b34610126576020600319360112610126576004355f526005602052602060405f20541515604051908152f35b34610126575f600319360112610126576020600154604051908152f35b34610126576020600319360112610126576004355f526007602052602060405f20541515604051908152f35b34610126575f600319360112610126576004545f1981019081116109e25761136f602091612511565b90549060031b1c604051908152f35b34610126575f60031936011261012657602060ff60025416604051908152f35b34610126576020600319360112610126576004356006548110156113ee5760065f527ff652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f0154604051908152602090f35b7f4e487b71000000000000000000000000000000000000000000000000000000005f52603260045260245ffd5b34610126575f60031936011261012657602073ffffffffffffffffffffffffffffffffffffffff5f5416604051908152f35b346101265760406003193601126101265760043567ffffffffffffffff811161012657806004016060600319833603011261012657602435801515809103610126575a917f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005c61124d5760017f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005d6114e3612383565b6114eb612556565b505f6114f782806123b9565b5f91505b8082106120055750506044850192611513848461248d565b9050151591611521816125c5565b9261152b826125c5565b9261153461253e565b5060405161154181612276565b5f80825260208201528215611ffe578360011c935b601f1961156561051b876125ad565b015f5b818110611fa35750508315611f9b57945b601f1961159e611588886125ad565b97611596604051998a612314565b8089526125ad565b015f5b818110611f84575050604051966115b7886122f7565b875260208701525f604087015260608601525f608086015260a085015260c084015260e0830152610100820152936115ef82806123b9565b90505f5b818110611acb57505060808501516116a5575b61167a847f10dd528db2c49add6545679b976df90d24c035d6a75b17f41b700e8c18ca53646105dd8861164d602082519201516040519384936040855260408501906124de565b0390a15f7f9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f005d5a90612269565b7f6f149831000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b61065992916116bd61062b60246116dd94018361248d565b94909361065360608901519389516020815160051b910120923691612866565b60208151910151905f5260205273ffffffffffffffffffffffffffffffffffffffff8060405f2016911690808203610b9f57505060c08401516117b6575b505060408201519161172c836142f4565b1561178a576105dd7f10dd528db2c49add6545679b976df90d24c035d6a75b17f41b700e8c18ca5364917f0a2dc548ed950accb40d5d78541f3954c5e182a8ecf19e581a4f2263f61f59d2602061167a96604051908152a193611606565b827fdb788c2b000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b602084015160e085015161010086015190604051926117d4846122db565b835260208301908082526040840192835251926020936040516117f78682612314565b5f8152926040516118088782612314565b5f8152945f915b87848410611a5f575050505061184d63ffffffff821662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b938160011b91808304600214901517156109e25760248661189863ffffffff6028951662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b9451947fffffffff00000000000000000000000000000000000000000000000000000000826040519882828b019b60e01b168b52805191829101868b015e8801917f919e13001cd3319be5a5a7cb189203be083674acb3fff23d05aae9c3ed86314d8584015260e01b1693846044830152805192839101604883015e010190602482015201848251919201905f5b86828210611a4b575050505090611948815f949303601f198101835282612314565b604051918291518091835e8101838152039060025afa156102ad575f519160a085015115611977575b5061171b565b73ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016803b15610126575f926119f992604051958694859384937fab750e7500000000000000000000000000000000000000000000000000000000855260606004860152606485019161275a565b907f213b3f40d7c113c1a012072fcd791fa44bf5166a2300121630bd3228e2b008276024840152604483015203915afa80156102ad57611a3b575b8080611971565b5f611a4591612314565b82611a34565b835185529384019390920191600101611926565b9091929695611a78908280610a2e610a288c8851612691565b9482518760011b90888204600214891517156109e257610a8582611a9b92612691565b845190600183018093116109e25760019360048c8193610ab2610a858398611ac298612691565b9601919061180f565b611ad981610bdb86806123b9565b6020810190611ae882826123b9565b80915060011b818104600214821517156109e257611b05906125c5565b905f5b818110611f30575050600160ff82516fffffffffffffffffffffffffffffffff811160071b67ffffffffffffffff82821c1160061b1763ffffffff82821c1160051b1761ffff82821c1160041b178282821c1160031b17600f82821c1160021b177d01010202020203030303030303030000000000000000000000000000000082821c1a179083821b1001161b611b9e816125c5565b915f5b828110611ed55750505b60018111611e5d5750611bbd90612684565b5191611bc981836123b9565b9190505f5b828110611c1b57505050604060019392611c09837f1cc9a0755dd734c1ebfe98b68ece200037e363eb366d0dee04e420e2f23cc010946123b9565b8351928352602083015250a1016115f3565b611c2981610d3184876123b9565b9b611c32612556565b508c606060208201910135805f52600560205260405f205415610fe8575060c08201518e91889115611d18578382611c85611c9093610da660e0611ca0990151608086015160011c90610d9636856126b2565b60408601359061298c565b9160a0610de0610dd58a806123b9565b9b60608d01805160405192611cb484612276565b60c0810135845260e060208501910135815260405193611cd385612276565b5f85525f6020860152611ce98151835190613c10565b15610e615791611d0a91600196959493602083519301519051915192613c72565b602084015282525201611bce565b60a084015115611d34575b611ca09382611c85611c9093610da8565b9050611d7773ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016928061248d565b60205f81611d88610f0d36886126b2565b604051918183925191829101835e8101838152039060025afa156102ad575f5193803b15610126575f92611df492604051968794859384937fab750e7500000000000000000000000000000000000000000000000000000000855260606004860152606485019161275a565b907f919e13001cd3319be5a5a7cb189203be083674acb3fff23d05aae9c3ed86314d6024840152604483015203915afa9081156102ad578f929389611c85611c9093611ca0978396611e4d575b50935050509350611d23565b5f611e5791612314565b5f611e41565b60011c5f5b818110611e6f5750611bab565b8060011b907f7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff811681036109e257611ea78285612691565b5191600181018091116109e25760019261107a611ec49287612691565b611ece8286612691565b5201611e62565b600190825181105f14611eff57611eec8184612691565b51611ef78287612691565b525b01611ba1565b7fcc1d2f838445db7aec431df9ee8a871f40e7aa5e064fc056633ef8c60fab7b06611f2a8287612691565b52611ef9565b611f3e81610d3187876123b9565b908060011b818104600214821517156109e2576020830135611f608287612691565b52600181018091116109e257611f7d608060019401359186612691565b5201611b08565b602090611f8f61262d565b82828b010152016115a1565b505f94611579565b602090604051611fb2816122bf565b604051611fbe816122db565b5f81525f848201525f60408201528152604051611fda81612276565b5f81525f84820152838201525f60408201525f606082015282828a01015201611568565b5f93611556565b909161201583610bdb86806123b9565b906120266111e360208401846123b9565b9280915060011b90808204600214901517156109e25780830361121e5750600191612050916126a5565b9201906114fb565b34610126575f60031936011261012657612070612337565b5f73ffffffffffffffffffffffffffffffffffffffff81547fffffffffffffffffffffffff000000000000000000000000000000000000000081168355167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e08280a3005b34610126575f600319360112610126576120ec612337565b6120f4612383565b6120fc612383565b740100000000000000000000000000000000000000007fffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff5f5416175f557f62e78cea01bee320cd4e420270b5ea74000d11b0c9f74754ebdbfc544b05a2586020604051338152a1005b34610126575f60031936011261012657602060ff5f5460a01c166040519015158152f35b34610126575f60031936011261012657602060405173ffffffffffffffffffffffffffffffffffffffff7f0000000000000000000000000000000000000000000000000000000000000000168152f35b34610126575f600319360112610126576020600454604051908152f35b34610126575f600319360112610126576020600654604051908152f35b3461012657602060031936011261012657602061136f600435612511565b34610126575f60031936011261012657807f312e302e3000000000000000000000000000000000000000000000000000000060209252f35b919082039182116109e257565b6040810190811067ffffffffffffffff82111761229257604052565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52604160045260245ffd5b6080810190811067ffffffffffffffff82111761229257604052565b6060810190811067ffffffffffffffff82111761229257604052565b610120810190811067ffffffffffffffff82111761229257604052565b90601f601f19910116810190811067ffffffffffffffff82111761229257604052565b73ffffffffffffffffffffffffffffffffffffffff5f5416330361235757565b7f118cdaa7000000000000000000000000000000000000000000000000000000005f523360045260245ffd5b60ff5f5460a01c1661239157565b7fd93c0665000000000000000000000000000000000000000000000000000000005f5260045ffd5b9035907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe181360301821215610126570180359067ffffffffffffffff821161012657602001918160051b3603831361012657565b91908110156113ee5760051b810135907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc181360301821215610126570190565b91908110156113ee5760051b810135907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0181360301821215610126570190565b9035907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe181360301821215610126570180359067ffffffffffffffff82116101265760200191813603831361012657565b90602080835192838152019201905f5b8181106124fb5750505090565b82518452602093840193909201916001016124ee565b6004548110156113ee5760045f5260205f2001905f90565b80548210156113ee575f5260205f2001905f90565b6040519061254b82612276565b5f6020838281520152565b60405190612563826122f7565b6060610100838281528260208201525f604082015260405161258481612276565b5f81525f6020820152838201525f60808201525f60a08201525f60c08201528260e08201520152565b67ffffffffffffffff81116122925760051b60200190565b906125cf826125ad565b6125dc6040519182612314565b828152601f196125ec82946125ad565b0190602036910137565b8115612600570490565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52601260045260245ffd5b6040519061263a826122bf565b815f81525f60208201525f6040820152606060405191612659836122bf565b81835281602084015281604084015281808401520152565b818102929181159184041417156109e257565b8051156113ee5760200190565b80518210156113ee5760209160051b010190565b919082018092116109e257565b809291039160e0831261012657604051906126cc826122bf565b819360608112610126577fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa06040918251612705816122db565b84358152602085013560208201528385013584820152855201126101265760c060609160405161273481612276565b83820135815260808201356020820152602085015260a081013560408501520135910152565b601f8260209493601f1993818652868601375f8582860101520116010190565b90612794906040939695949660608452606084019161275a565b9460208201520152565b9035907fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8181360301821215610126570190565b908210156113ee576127e89160051b81019061279e565b90565b909291925f5b81811061282457847f89211474000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b846128308284866127d1565b351461283e576001016127f1565b916127e89394506127d1565b67ffffffffffffffff811161229257601f01601f191660200190565b9291926128728261284a565b916128806040519384612314565b829481845281830111610126578281602093845f960137010152565b9080601f83011215610126578160206127e893359101612866565b9080601f83011215610126578135916128cf836125ad565b926128dd6040519485612314565b80845260208085019160051b830101918383116101265760208101915b83831061290957505050505090565b823567ffffffffffffffff8111610126578201906040601f198388030112610126576040519061293882612276565b6020830135600281101561012657825260408301359167ffffffffffffffff83116101265761296f8860208096958196010161289c565b838201528152019201916128fa565b5f1981146109e25760010190565b93929091612998612556565b5081945f936020820135908082036130ed575060808236031261012657604051936129c2856122bf565b8235948581528260208201526040840194853567ffffffffffffffff81116101265785019060808236031261012657604051916129fe836122bf565b803567ffffffffffffffff811161012657612a1c90369083016128b7565b8352602081013567ffffffffffffffff811161012657612a3f90369083016128b7565b6020840152604081013567ffffffffffffffff811161012657612a6590369083016128b7565b604084015260608101359067ffffffffffffffff821161012657612a8b913691016128b7565b6060830152604083019182526060860192833567ffffffffffffffff811161012657612aba903690890161289c565b6060820152612ac761262d565b505191519060405192612ad9846122bf565b8352600160208401526040830152606082015260c083015115612ffb57612b119150610100830151608084015191610da08383612691565b505b612b2a612b20858561279e565b60408101906123b9565b9050865b818110612df5575050806020612b6792519187612b516080830194855190612691565b520151815191612b608361297e565b9052612691565b52612b718361432d565b15612dc957612b89612b83838361279e565b806123b9565b855b818110612d5a57505050612bac612ba2838361279e565b60208101906123b9565b855b818110612ceb57505050612bc5612b20838361279e565b855b818110612c7857505050612be891612bde9161279e565b60608101906123b9565b839291925b818110612bfb575050505050565b612c0681838661240d565b356002811015612c7457906001809214612c21575b01612bed565b837fa494dac4b7184843583f972e06783e2c3bb47f4f0137b8df52a860df07219f8c612c5b612c5184878a61240d565b602081019061248d565b90612c6c6040519283928784613bf9565b0390a2612c1b565b8580fd5b612c8381838561240d565b356002811015612ce757906001809214612c9e575b01612bc7565b867f9c61b290f631097f56273cf4daf40df1ff9ccc33f101d464837da1f5ae18bd59612cce612c5184878961240d565b90612cdf6040519283928784613bf9565b0390a2612c98565b8780fd5b612cf681838561240d565b356002811015612ce757906001809214612d11575b01612bae565b867f48243873b4752ddcb45e0d7b11c4c266583e5e099a0b798fdd9c1af7d49324f3612d41612c5184878961240d565b90612d526040519283928784613bf9565b0390a2612d0b565b612d6581838561240d565b356002811015612ce757906001809214612d80575b01612b8b565b867f3a134d01c07803003c63301717ddc4612e6c47ae408eeea3222cded532d02ae6612db0612c5184878961240d565b90612dc16040519283928784613bf9565b0390a2612d7a565b602484847f39a940c5000000000000000000000000000000000000000000000000000000008252600452fd5b612e09612c5182610bdb612b208a8a61279e565b810190606081830312612ff75780359173ffffffffffffffffffffffffffffffffffffffff8316809303612ff357602082013567ffffffffffffffff8111612fef5781612e5791840161289c565b9160408101359067ffffffffffffffff8211612fe057612e7892910161289c565b90604051917f33a89203000000000000000000000000000000000000000000000000000000008352876004840152604060248401528b8380612ebd6044820186614000565b038183885af1928315612fe4578c93612f60575b50825160208401208151602083012003612f25575060019392917fcddb327adb31fe5437df2a8c68301bb13a6baae432a804838caaf682506aadf191612f1c60405192839283614025565b0390a201612b2e565b9050612f5c6040519283927fc504fada00000000000000000000000000000000000000000000000000000000845260048401614025565b0390fd5b9092503d808d833e612f728183612314565b810190602081830312612fe05780519067ffffffffffffffff8211612fdc570181601f82011215612fe057805190612fa98261284a565b92612fb76040519485612314565b82845260208383010111612fdc57818e9260208093018386015e83010152915f612ed1565b8d80fd5b8c80fd5b6040513d8e823e3d90fd5b8b80fd5b8a80fd5b8980fd5b60a08301511561300d575b5050612b13565b61305e9060205f8161305673ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016968a61248d565b959094613983565b604051918183925191829101835e8101838152039060025afa156102ad575f5192803b15610126575f9286926130c3604051968795869485947fab750e750000000000000000000000000000000000000000000000000000000086526004860161277a565b03915afa80156102ad576130d8575b80613006565b6130e59196505f90612314565b5f945f6130d2565b7f18f639d8000000000000000000000000000000000000000000000000000000005f5260045260245260445ffd5b939290915f94613129612556565b5082956020820135948086036138f557506080823603126101265760405194613151866122bf565b8235958681528160208201526040840194853567ffffffffffffffff811161012657850190608082360312610126576040519161318d836122bf565b803567ffffffffffffffff8111610126576131ab90369083016128b7565b8352602081013567ffffffffffffffff8111610126576131ce90369083016128b7565b6020840152604081013567ffffffffffffffff8111610126576131f490369083016128b7565b604084015260608101359067ffffffffffffffff82116101265761321a913691016128b7565b6060830152604083019182526060860192833567ffffffffffffffff811161012657613249903690890161289c565b606082015261325661262d565b505191519060405192613268846122bf565b83525f60208401526040830152606082015260c08701511561380b5761329f9150610100870151608088015191610da08383612691565b505b6132ae612b20858561279e565b9050825b8181106136505750506132e38551876132d16080890192835190612691565b526020870151815191612b608361297e565b529260ff60025416906001546132f88161297e565b6001559186925f5b8281106135aa575050600154600160ff600254161b14613551575b506040015261332d612b83838361279e565b90845b8281106134e257505050613347612ba2838361279e565b90845b82811061347357505050613361612b20838361279e565b90845b8281106134005750505061337b91612bde9161279e565b9290825b84811061338d575050505050565b61339881868461240d565b3560028110156133fc579060018092146133b3575b0161337f565b837fa494dac4b7184843583f972e06783e2c3bb47f4f0137b8df52a860df07219f8c6133e3612c51848a8861240d565b906133f46040519283928784613bf9565b0390a26133ad565b8480fd5b61340b81848461240d565b35600281101561346f57906001809214613426575b01613364565b877f9c61b290f631097f56273cf4daf40df1ff9ccc33f101d464837da1f5ae18bd59613456612c5184888861240d565b906134676040519283928784613bf9565b0390a2613420565b8680fd5b61347e81848461240d565b35600281101561346f57906001809214613499575b0161334a565b877f48243873b4752ddcb45e0d7b11c4c266583e5e099a0b798fdd9c1af7d49324f36134c9612c5184888861240d565b906134da6040519283928784613bf9565b0390a2613493565b6134ed81848461240d565b35600281101561346f57906001809214613508575b01613330565b877f3a134d01c07803003c63301717ddc4612e6c47ae408eeea3222cded532d02ae6613538612c5184888861240d565b906135496040519283928784613bf9565b0390a2613502565b90916002549068010000000000000000821015612292576040926135808360016135a395016002556002612529565b81549060031b905f1985831b921b191617905560035f5260205f20015490613e49565b919061331b565b9093600190818616613618577f405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace830181905560035f527fc2575a0e9e593c00f959f8c92f12db2869c3395a3b0502d05e2516446f71f85b83015461360d91613e49565b945b811c9101613300565b60025f527f405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace83015461364a9190613e49565b9461360f565b613664612c5182610bdb612b208a8a61279e565b810190606081830312612c745780359173ffffffffffffffffffffffffffffffffffffffff831680930361346f57602082013567ffffffffffffffff8111612ce757816136b291840161289c565b9160408101359067ffffffffffffffff82116137fc576136d392910161289c565b90604051917f33a89203000000000000000000000000000000000000000000000000000000008352866004840152604060248401528783806137186044820186614000565b038183885af1928315613800578893613780575b50825160208401208151602083012003612f25575060019392917fcddb327adb31fe5437df2a8c68301bb13a6baae432a804838caaf682506aadf19161377760405192839283614025565b0390a2016132b2565b9092503d8089833e6137928183612314565b8101906020818303126137fc5780519067ffffffffffffffff8211612ff7570181601f820112156137fc578051906137c98261284a565b926137d76040519485612314565b82845260208383010111612ff757818a9260208093018386015e83010152915f61372c565b8880fd5b6040513d8a823e3d90fd5b60a08701511561381d575b50506132a1565b6138669060205f8161305673ffffffffffffffffffffffffffffffffffffffff7f000000000000000000000000000000000000000000000000000000000000000016968a61248d565b604051918183925191829101835e8101838152039060025afa156102ad575f5192803b15610126575f9285926138cb604051968795869485947fab750e750000000000000000000000000000000000000000000000000000000086526004860161277a565b03915afa80156102ad576138e0575b80613816565b6138ed9192505f90612314565b5f905f6138da565b85907f18f639d8000000000000000000000000000000000000000000000000000000005f5260045260245260445ffd5b80518051916040602083015192015160208201516020815191015191606060408501519401519460405196602088015260408701526060860152608085015260a084015260c083015260e082015260e081526127e861010082612314565b60608101518151602083015190919015613bf05760406301000000935b015190805190815163ffffffff166139da9062ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b916139e490613e8c565b6020820151805163ffffffff16613a1d9062ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b90613a2790613e8c565b90604084015192835163ffffffff16613a629062ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b93613a6c90613e8c565b946060015195865163ffffffff16613aa69062ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b96613ab090613e8c565b976040519a8b9a60208c015260e01b7fffffffff000000000000000000000000000000000000000000000000000000001660408b015260448a015260e01b7fffffffff000000000000000000000000000000000000000000000000000000001660648901528051602081920160688a015e87019060e01b7fffffffff0000000000000000000000000000000000000000000000000000000016606882015281516020819301606c83015e016068019060e01b7fffffffff0000000000000000000000000000000000000000000000000000000016600482015281516020819301600883015e016004019060e01b7fffffffff0000000000000000000000000000000000000000000000000000000016600482015281516020819301600883015e01600401600481015f905203600401601f19810182526127e89082612314565b60405f936139a0565b6040906127e894928152816020820152019161275a565b80158015613c62575b8015613c5a575b8015613c4a575b613c44576401000003d01960078180938181800909089180091490565b50505f90565b506401000003d019821015613c27565b508115613c20565b506401000003d019811015613c19565b92939290915f90808303613e2c5750506401000003d0195f948308613c9b57505090505f905f90565b5f613cad926401000003d0199261427d565b939091905b8415158581613e1b575b5080613e13575b15613db55780948060016401000003d01984925b613d2b575050505080613cfe5750906401000003d019809281808780098092099509900990565b807f4e487b7100000000000000000000000000000000000000000000000000000000602492526012600452fd5b613d3984829a94959a6125f6565b918094613d88576401000003d0199083096401000003d01903906401000003d01982116109e257613d7a6401000003d019613d8093889608959a8094612671565b90612269565b929083613cd7565b6024867f4e487b710000000000000000000000000000000000000000000000000000000081526012600452fd5b60646040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152600e60248201527f496e76616c6964206e756d6265720000000000000000000000000000000000006044820152fd5b506001613cc3565b6401000003d019915014155f613cbc565b613e40936401000003d01993969296614082565b93909190613cb2565b5f9060209260405190848201928352604082015260408152613e6c606082612314565b604051918291518091835e8101838152039060025afa156102ad575f5190565b8051606092915f915b808310613ea157505050565b909193613ee863ffffffff6020613eb88887612691565b5101515160021c1662ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b906020613ef58786612691565b510151613f028786612691565b51516002811015613fd3576004602093613fca937fffffffff000000000000000000000000000000000000000000000000000000008680600199613f69879862ff00ff63ff00ff008260081b169160081c161763ffffffff808260101b169160101c161790565b94846040519b888d995191829101868b015e88019260e01b1683830152805192839101602483015e01019160e01b168382015203017fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe4810184520182612314565b94019190613e95565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52602160045260245ffd5b90601f19601f602080948051918291828752018686015e5f8582860101520116010190565b909161403c6127e893604084526040840190614000565b916020818403910152614000565b8054680100000000000000008110156122925761406c91600182018155612529565b5f19829392549160031b92831b921b1916179055565b949291851580614275575b61426957801580614261575b614257576040516080916140ad8383612314565b8236833786156126005786948580928180600180098087529781896001099c602088019d8e5282604089019d8e8c8152516001099160608a019283526040519e8f6140f7906122bf565b5190098d525190099460208b019586525190099860408901998a5251900960608701908152865188511480159061424b575b156141ed57849283808093816040519c856141458f9788612314565b368737518c516141559083612269565b900884525185516141669083612269565b90089860208301998a5281808b8180808089518a5190099360408a019485528185518b5190096060909a01998a5251800988516141a39083612269565b900881808751855190096002096141ba9083612269565b90089c519351905190096141ce8c83612269565b900890099251905190096141e29083612269565b900894510991929190565b60646040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601e60248201527f557365206a6163446f75626c652066756e6374696f6e20696e737465616400006044820152fd5b50815181511415614129565b5092506001919050565b508215614099565b94509092506001919050565b50811561408d565b9391929092811561260057600182806142ea818080809781806142da9e818f81818192099a8b96818f8180828193099a880960040998800990099280096003090891816142cd8183800882612269565b81858009089e8f83612269565b9008900993800960080983612269565b9008940960020990565b805f52600560205260405f2054155f146143285761431381600461404a565b600454905f52600560205260405f2055600190565b505f90565b805f52600760205260405f2054155f146143285761434c81600661404a565b600654905f52600760205260405f2055600190565b60041115613fd357565b815191906041830361439b576143949250602082015190606060408401519301515f1a9061446c565b9192909190565b50505f9160029190565b6143ae81614361565b806143b7575050565b6143c081614361565b600181036143f0577ff645eedf000000000000000000000000000000000000000000000000000000005f5260045ffd5b6143f981614361565b6002810361442d57507ffce698f7000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b60039061443981614361565b146144415750565b7fd78bce0c000000000000000000000000000000000000000000000000000000005f5260045260245ffd5b91907f7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a084116144f0579160209360809260ff5f9560405194855216868401526040830152606082015282805260015afa156102ad575f5173ffffffffffffffffffffffffffffffffffffffff8116156144e657905f905f90565b505f906001905f90565b5050505f916003919056
    /// ```
    #[rustfmt::skip]
    #[allow(clippy::all)]
    pub static DEPLOYED_BYTECODE: alloy_sol_types::private::Bytes = alloy_sol_types::private::Bytes::from_static(
        b"`\x80\x80`@R`\x046\x10\x15a\0\x12W_\x80\xFD[_5`\xE0\x1C\x90\x81c\r\x8En,\x14a\"1WP\x80c1\xEEbB\x14a\"\x13W\x80c@\xF3MB\x14a!\xF6W\x80cY\xBA\x92X\x14a!\xD9W\x80c[fk\x1E\x14a!\x89W\x80c\\\x97Z\xBB\x14a!eW\x80cc\xA5\x99\xA4\x14a \xD4W\x80cqP\x18\xA6\x14a XW\x80c\x82\xD3*\xD8\x14a\x14MW\x80c\x8D\xA5\xCB[\x14a\x14\x1BW\x80c\x9A\xD9\x1DL\x14a\x13\x9EW\x80c\xA0`V\xF7\x14a\x13~W\x80c\xBD\xEBD-\x14a\x13FW\x80c\xC1\xB0\xBE\xD7\x14a\x13\x1AW\x80c\xC4IV\xD1\x14a\x12\xFDW\x80c\xC8y\xDB\xE4\x14a\x12\xD1W\x80c\xE38E\xCF\x14a\x12uW\x80c\xED<\xF9\x1F\x14a\x03\xD9W\x80c\xF2\xFD\xE3\x8B\x14a\x03\x08W\x80c\xFD\xDDH7\x14a\x01*Wc\xFE\x18\xAB\x91\x14a\x01\x03W_\x80\xFD[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\x01`\xFF`\x02T\x16\x1B`@Q\x90\x81R\xF3[_\x80\xFD[4a\x01&W_`\x03\x196\x01\x12a\x01&W`@Q\x7F<\xAD\xF4I\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`\x04\x82\x01R` \x81`$\x81s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16Z\xFA\x90\x81\x15a\x02\xADW_\x91a\x02\xB8W[P` s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x91`\x04`@Q\x80\x94\x81\x93\x7F\\\x97Z\xBB\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83R\x16Z\xFA\x80\x15a\x02\xADW_\x90a\x02qW[` \x91P`\xFF_T`\xA0\x1C\x16\x90\x81\x15a\x02iW[P`@Q\x90\x15\x15\x81R\xF3[\x90P\x82a\x02^V[P` \x81=` \x11a\x02\xA5W[\x81a\x02\x8B` \x93\x83a#\x14V[\x81\x01\x03\x12a\x01&WQ\x80\x15\x15\x81\x03a\x01&W` \x90a\x02JV[=\x91Pa\x02~V[`@Q=_\x82>=\x90\xFD[\x90P` \x81=` \x11a\x03\0W[\x81a\x02\xD3` \x93\x83a#\x14V[\x81\x01\x03\x12a\x01&WQs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x81\x03a\x01&W` a\x01\xF5V[=\x91Pa\x02\xC6V[4a\x01&W` `\x03\x196\x01\x12a\x01&W`\x045s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x80\x91\x03a\x01&Wa\x03Ba#7V[\x80\x15a\x03\xADWs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF_T\x82\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82\x16\x17_U\x16\x7F\x8B\xE0\x07\x9CS\x16Y\x14\x13D\xCD\x1F\xD0\xA4\xF2\x84\x19I\x7F\x97\"\xA3\xDA\xAF\xE3\xB4\x18okdW\xE0_\x80\xA3\0[\x7F\x1EO\xBD\xF7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R_`\x04R`$_\xFD[4a\x01&W` `\x03\x196\x01\x12a\x01&W`\x045g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x80`\x04\x01```\x03\x19\x836\x03\x01\x12a\x01&W\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0\\a\x12MW`\x01\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0]a\x04`a#\x83V[a\x04ha%VV[P_\x90a\x04u\x81\x80a#\xB9V[_\x91P[\x80\x82\x10a\x11\xC2WPP`D\x83\x01\x91a\x04\x91\x83\x83a$\x8DV[\x90P\x15\x15a\x04\x9E\x82a%\xC5V[\x91a\x04\xA8\x81a%\xC5V[\x91a\x04\xB1a%>V[P`@Qa\x04\xBE\x81a\"vV[_\x80\x82R` \x82\x01R\x81\x15a\x11\xBBW\x82`\x01\x1C\x92[`\x1F\x19a\x04\xF8a\x04\xE2\x86a%\xADV[\x95a\x04\xF0`@Q\x97\x88a#\x14V[\x80\x87Ra%\xADV[\x01_[\x81\x81\x10a\x11`WPP\x82\x15a\x11XW\x93[`\x1F\x19a\x051a\x05\x1B\x87a%\xADV[\x96a\x05)`@Q\x98\x89a#\x14V[\x80\x88Ra%\xADV[\x01_[\x81\x81\x10a\x11AWPP`@Q\x95a\x05J\x87a\"\xF7V[\x86R` \x86\x01R_`@\x86\x01R``\x85\x01R_`\x80\x85\x01R_`\xA0\x85\x01R`\xC0\x84\x01R`\xE0\x83\x01Ra\x01\0\x82\x01R\x92a\x05\x83\x82\x80a#\xB9V[\x90P_[\x81\x81\x10a\x0B\xCDWPP`\x80\x84\x01Qa\x06\x13W[\x7F\x10\xDDR\x8D\xB2\xC4\x9A\xDDeEg\x9B\x97m\xF9\r$\xC05\xD6\xA7[\x17\xF4\x1Bp\x0E\x8C\x18\xCASda\x05\xDD\x85a\x05\xEB` \x82Q\x92\x01Q`@Q\x93\x84\x93`@\x85R`@\x85\x01\x90a$\xDEV[\x90\x83\x82\x03` \x85\x01Ra$\xDEV[\x03\x90\xA1_\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0]\0[a\x06Y\x92\x91a\x063a\x06+`$a\x06b\x94\x01\x83a$\x8DV[\x94\x90\x92a$\x8DV[\x94\x90\x93a\x06S``\x88\x01Q\x93\x88Q` \x81Q`\x05\x1B\x91\x01 \x926\x91a(fV[\x90aCkV[\x90\x93\x91\x93aC\xA5V[` \x81Q\x91\x01Q\x90_R` Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x80`@_ \x16\x91\x16\x90\x80\x82\x03a\x0B\x9FWPP`\xC0\x83\x01Qa\x079W[PP`@\x81\x01Q\x90a\x06\xB1\x82aB\xF4V[\x15a\x07\rWa\x05\xDD\x90\x7F\n-\xC5H\xED\x95\n\xCC\xB4\r]xT\x1F9T\xC5\xE1\x82\xA8\xEC\xF1\x9EX\x1AO\"c\xF6\x1FY\xD2` \x7F\x10\xDDR\x8D\xB2\xC4\x9A\xDDeEg\x9B\x97m\xF9\r$\xC05\xD6\xA7[\x17\xF4\x1Bp\x0E\x8C\x18\xCASd\x94`@Q\x90\x81R\xA1\x91\x83a\x05\x9AV[P\x7F\xDBx\x8C+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[` \x83\x01Q`\xE0\x84\x01Qa\x01\0\x85\x01Q\x90`@Q\x92a\x07W\x84a\"\xDBV[\x83R` \x83\x01\x90\x80\x82R`@\x84\x01\x92\x83RQ\x92` \x93`@Qa\x07z\x86\x82a#\x14V[_\x81R\x92`@Qa\x07\x8B\x87\x82a#\x14V[_\x81R\x94_\x91[\x87\x84\x84\x10a\n\x0FWPPPPa\x07\xD0c\xFF\xFF\xFF\xFF\x82\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x93\x81`\x01\x1B\x91\x80\x83\x04`\x02\x14\x90\x15\x17\x15a\t\xE2W`$\x86a\x08\x1Bc\xFF\xFF\xFF\xFF`(\x95\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x94Q\x94\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82`@Q\x98\x82\x82\x8B\x01\x9B`\xE0\x1B\x16\x8BR\x80Q\x91\x82\x91\x01\x86\x8B\x01^\x88\x01\x91\x7F\x91\x9E\x13\0\x1C\xD31\x9B\xE5\xA5\xA7\xCB\x18\x92\x03\xBE\x086t\xAC\xB3\xFF\xF2=\x05\xAA\xE9\xC3\xED\x861M\x85\x84\x01R`\xE0\x1B\x16\x93\x84`D\x83\x01R\x80Q\x92\x83\x91\x01`H\x83\x01^\x01\x01\x90`$\x82\x01R\x01\x84\x82Q\x91\x92\x01\x90_[\x86\x82\x82\x10a\t\xCEWPPPP\x90a\x08\xCB\x81_\x94\x93\x03`\x1F\x19\x81\x01\x83R\x82a#\x14V[`@Q\x91\x82\x91Q\x80\x91\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xADW_Q\x91`\xA0\x84\x01Q\x15a\x08\xFAW[Pa\x06\xA0V[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x80;\x15a\x01&W_\x92a\t|\x92`@Q\x95\x86\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R```\x04\x86\x01R`d\x85\x01\x91a'ZV[\x90\x7F!;?@\xD7\xC1\x13\xC1\xA0\x12\x07/\xCDy\x1F\xA4K\xF5\x16j#\0\x12\x160\xBD2(\xE2\xB0\x08'`$\x84\x01R`D\x83\x01R\x03\x91Z\xFA\x80\x15a\x02\xADWa\t\xBEW[\x80\x80a\x08\xF4V[_a\t\xC8\x91a#\x14V[\x81a\t\xB7V[\x83Q\x85R\x93\x84\x01\x93\x90\x92\x01\x91`\x01\x01a\x08\xA9V[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x11`\x04R`$_\xFD[\x90\x91\x92\x96\x95a\nb\x90\x82\x80a\n.a\n(\x8C\x88Qa&\x91V[Qa9%V[`@Q\x95\x84\x87\x95Q\x91\x82\x91\x01\x84\x87\x01^\x84\x01\x90\x82\x82\x01_\x81R\x81Q\x93\x84\x92\x01\x90^\x01\x01_\x81R\x03`\x1F\x19\x81\x01\x83R\x82a#\x14V[\x94\x82Q\x87`\x01\x1B\x90\x88\x82\x04`\x02\x14\x89\x15\x17\x15a\t\xE2Wa\n\x85\x82a\n\x8B\x92a&\x91V[Qa9\x83V[\x84Q\x90`\x01\x83\x01\x80\x93\x11a\t\xE2W`\x01\x93`\x04\x8C\x81\x93a\n\xB2a\n\x85\x83\x98a\x0B\x96\x98a&\x91V[\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83\x80a\x0B\x0Bc\xFF\xFF\xFF\xFF\x86Q`\x02\x1C\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[a\x0BAc\xFF\xFF\xFF\xFF\x86Q`\x02\x1C\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x95\x84`@Q\x9D\x8B\x8F\x82\x81\x9EQ\x93\x84\x93\x01\x91\x01^\x8B\x01\x92`\xE0\x1B\x16\x83\x83\x01R\x80Q\x92\x83\x91\x01`$\x83\x01^\x01\x01\x92`\xE0\x1B\x16\x84\x83\x01R\x80Q\x92\x83\x91\x01`\x08\x83\x01^\x01\x01_\x83\x82\x01R\x03\x01`\x1F\x19\x81\x01\x83R\x82a#\x14V[\x96\x01\x91\x90a\x07\x92V[\x7F\xE6\xD4KL\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$R`D_\xFD[a\x0B\xE1\x81a\x0B\xDB\x86\x80a#\xB9V[\x90a$\rV[` \x81\x01\x90a\x0B\xF0\x82\x82a#\xB9V[\x80\x91P`\x01\x1B\x81\x81\x04`\x02\x14\x82\x15\x17\x15a\t\xE2Wa\x0C\r\x90a%\xC5V[\x90_[\x81\x81\x10a\x10\xEDWPP`\x01`\xFF\x82Qo\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11`\x07\x1Bg\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x82\x1C\x11`\x06\x1B\x17c\xFF\xFF\xFF\xFF\x82\x82\x1C\x11`\x05\x1B\x17a\xFF\xFF\x82\x82\x1C\x11`\x04\x1B\x17\x82\x82\x82\x1C\x11`\x03\x1B\x17`\x0F\x82\x82\x1C\x11`\x02\x1B\x17}\x01\x01\x02\x02\x02\x02\x03\x03\x03\x03\x03\x03\x03\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82\x82\x1C\x1A\x17\x90\x83\x82\x1B\x10\x01\x16\x1Ba\x0C\xA6\x81a%\xC5V[\x91_[\x82\x81\x10a\x10\x92WPP[`\x01\x81\x11a\x10\x13WPa\x0C\xC5\x90a&\x84V[Q\x91a\x0C\xD1\x81\x83a#\xB9V[\x91\x90P_[\x82\x81\x10a\r#WPPP`@`\x01\x93\x92a\r\x11\x83\x7F\x1C\xC9\xA0u]\xD74\xC1\xEB\xFE\x98\xB6\x8E\xCE \x007\xE3c\xEB6m\r\xEE\x04\xE4 \xE2\xF2<\xC0\x10\x94a#\xB9V[\x83Q\x92\x83R` \x83\x01RP\xA1\x01a\x05\x87V[a\r7\x81a\r1\x84\x87a#\xB9V[\x90a$MV[\x9Aa\r@a%VV[P` \x8C\x01``\x8D\x015\x80_R`\x05` R`@_ T\x15a\x0F\xE8WP`\xC0\x82\x01Q\x87\x92\x91\x8E\x91\x15a\x0E\x99W\x92\x82\x91`@a\r\xBBa\r\xE9\x96a\r\xA6`\xE0a\r\xC4\x98\x01Q`\x80\x88\x01Q`\x01\x1C\x90a\r\x966\x85a&\xB2V[a\r\xA0\x83\x83a&\x91V[Ra&\x91V[P[a\r\xB2\x8C\x80a#\xB9V[\x90\x915\x91a'\xEBV[\x91\x015\x90a)\x8CV[\x86\x8D`\xA0a\r\xE0a\r\xD5\x8A\x80a#\xB9V[`\x80\x85\x015\x91a'\xEBV[\x91\x015\x90a1\x1BV[\x9A``\x8C\x01\x80Q`@Q\x92a\r\xFD\x84a\"vV[`\xC0\x81\x015\x84R`\xE0` \x85\x01\x91\x015\x81R`@Q\x93a\x0E\x1C\x85a\"vV[_\x85R_` \x86\x01Ra\x0E2\x81Q\x83Q\x90a<\x10V[\x15a\x0EaW\x91a\x0ES\x91`\x01\x96\x95\x94\x93` \x83Q\x93\x01Q\x90Q\x91Q\x92a<rV[` \x84\x01R\x82RR\x01a\x0C\xD6V[`D\x91`@Q\x91\x7F\xB8\xA0\xE8\xA1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83RQ`\x04\x83\x01RQ`$\x82\x01R\xFD[`\xA0\x83\x01Q\x15a\x0E\xB8W[\x92a\r\xC4\x92\x91`@a\r\xBBa\r\xE9\x96a\r\xA8V[\x92P\x90a\x0E\xFCs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x92\x80a$\x8DV[` _\x81a\x0F\x12a\x0F\r6\x8Aa&\xB2V[a9%V[`@Q\x91\x81\x83\x92Q\x91\x82\x91\x01\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xADW_Q\x93\x80;\x15a\x01&W_\x92a\x0F~\x92`@Q\x96\x87\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R```\x04\x86\x01R`d\x85\x01\x91a'ZV[\x90\x7F\x91\x9E\x13\0\x1C\xD31\x9B\xE5\xA5\xA7\xCB\x18\x92\x03\xBE\x086t\xAC\xB3\xFF\xF2=\x05\xAA\xE9\xC3\xED\x861M`$\x84\x01R`D\x83\x01R\x03\x91Z\xFA\x92\x83\x15a\x02\xADW\x8E`@a\r\xBB\x8B\x93a\r\xC4\x96a\r\xE9\x98a\x0F\xD8W[P\x93\x96PPP\x91\x92Pa\x0E\xA4V[_a\x0F\xE2\x91a#\x14V[_a\x0F\xCAV[\x7F\xF9\x84\x9E\xA3\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[`\x01\x1C_[\x81\x81\x10a\x10%WPa\x0C\xB3V[\x80`\x01\x1B\x90\x7F\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x81\x03a\t\xE2Wa\x10]\x82\x85a&\x91V[Q\x91`\x01\x81\x01\x80\x91\x11a\t\xE2W`\x01\x92a\x10za\x10\x81\x92\x87a&\x91V[Q\x90a>IV[a\x10\x8B\x82\x86a&\x91V[R\x01a\x10\x18V[`\x01\x90\x82Q\x81\x10_\x14a\x10\xBCWa\x10\xA9\x81\x84a&\x91V[Qa\x10\xB4\x82\x87a&\x91V[R[\x01a\x0C\xA9V[\x7F\xCC\x1D/\x83\x84E\xDBz\xECC\x1D\xF9\xEE\x8A\x87\x1F@\xE7\xAA^\x06O\xC0Vc>\xF8\xC6\x0F\xAB{\x06a\x10\xE7\x82\x87a&\x91V[Ra\x10\xB6V[a\x10\xFB\x81a\r1\x87\x87a#\xB9V[\x90\x80`\x01\x1B\x81\x81\x04`\x02\x14\x82\x15\x17\x15a\t\xE2W` \x83\x015a\x11\x1D\x82\x87a&\x91V[R`\x01\x81\x01\x80\x91\x11a\t\xE2Wa\x11:`\x80`\x01\x94\x015\x91\x86a&\x91V[R\x01a\x0C\x10V[` \x90a\x11La&-V[\x82\x82\x8A\x01\x01R\x01a\x054V[P_\x93a\x05\x0CV[` \x90`@Qa\x11o\x81a\"\xBFV[`@Qa\x11{\x81a\"\xDBV[_\x81R_\x84\x82\x01R_`@\x82\x01R\x81R`@Qa\x11\x97\x81a\"vV[_\x81R_\x84\x82\x01R\x83\x82\x01R_`@\x82\x01R_``\x82\x01R\x82\x82\x89\x01\x01R\x01a\x04\xFBV[_\x92a\x04\xD3V[\x90\x92a\x11\xD2\x84a\x0B\xDB\x85\x80a#\xB9V[\x90a\x11\xECa\x11\xE3` \x84\x01\x84a#\xB9V[\x93\x80\x91Pa#\xB9V[\x92\x80\x91P`\x01\x1B\x90\x80\x82\x04`\x02\x14\x90\x15\x17\x15a\t\xE2W\x80\x83\x03a\x12\x1EWP`\x01\x91a\x12\x16\x91a&\xA5V[\x93\x01\x90a\x04yV[\x82\x7F\xD3\xBE\xE7\x8D\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$R`D_\xFD[\x7F>\xE5\xAE\xB5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04_\xFD[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `@Q\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x81R\xF3[4a\x01&W` `\x03\x196\x01\x12a\x01&W`\x045_R`\x05` R` `@_ T\x15\x15`@Q\x90\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\x01T`@Q\x90\x81R\xF3[4a\x01&W` `\x03\x196\x01\x12a\x01&W`\x045_R`\x07` R` `@_ T\x15\x15`@Q\x90\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W`\x04T_\x19\x81\x01\x90\x81\x11a\t\xE2Wa\x13o` \x91a%\x11V[\x90T\x90`\x03\x1B\x1C`@Q\x90\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\xFF`\x02T\x16`@Q\x90\x81R\xF3[4a\x01&W` `\x03\x196\x01\x12a\x01&W`\x045`\x06T\x81\x10\x15a\x13\xEEW`\x06_R\x7F\xF6R\"#\x13\xE2\x84YR\x8D\x92\x0Be\x11\\\x16\xC0O>\xFC\x82\xAA\xED\xC9{\xE5\x9F?7|\r?\x01T`@Q\x90\x81R` \x90\xF3[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`2`\x04R`$_\xFD[4a\x01&W_`\x03\x196\x01\x12a\x01&W` s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF_T\x16`@Q\x90\x81R\xF3[4a\x01&W`@`\x03\x196\x01\x12a\x01&W`\x045g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x80`\x04\x01```\x03\x19\x836\x03\x01\x12a\x01&W`$5\x80\x15\x15\x80\x91\x03a\x01&WZ\x91\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0\\a\x12MW`\x01\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0]a\x14\xE3a#\x83V[a\x14\xEBa%VV[P_a\x14\xF7\x82\x80a#\xB9V[_\x91P[\x80\x82\x10a \x05WPP`D\x85\x01\x92a\x15\x13\x84\x84a$\x8DV[\x90P\x15\x15\x91a\x15!\x81a%\xC5V[\x92a\x15+\x82a%\xC5V[\x92a\x154a%>V[P`@Qa\x15A\x81a\"vV[_\x80\x82R` \x82\x01R\x82\x15a\x1F\xFEW\x83`\x01\x1C\x93[`\x1F\x19a\x15ea\x05\x1B\x87a%\xADV[\x01_[\x81\x81\x10a\x1F\xA3WPP\x83\x15a\x1F\x9BW\x94[`\x1F\x19a\x15\x9Ea\x15\x88\x88a%\xADV[\x97a\x15\x96`@Q\x99\x8Aa#\x14V[\x80\x89Ra%\xADV[\x01_[\x81\x81\x10a\x1F\x84WPP`@Q\x96a\x15\xB7\x88a\"\xF7V[\x87R` \x87\x01R_`@\x87\x01R``\x86\x01R_`\x80\x86\x01R`\xA0\x85\x01R`\xC0\x84\x01R`\xE0\x83\x01Ra\x01\0\x82\x01R\x93a\x15\xEF\x82\x80a#\xB9V[\x90P_[\x81\x81\x10a\x1A\xCBWPP`\x80\x85\x01Qa\x16\xA5W[a\x16z\x84\x7F\x10\xDDR\x8D\xB2\xC4\x9A\xDDeEg\x9B\x97m\xF9\r$\xC05\xD6\xA7[\x17\xF4\x1Bp\x0E\x8C\x18\xCASda\x05\xDD\x88a\x16M` \x82Q\x92\x01Q`@Q\x93\x84\x93`@\x85R`@\x85\x01\x90a$\xDEV[\x03\x90\xA1_\x7F\x9Bw\x9B\x17B-\r\xF9\"#\x01\x8B2\xB4\xD1\xFAF\xE0qr=h\x17\xE2Hm\0;\xEC\xC5_\0]Z\x90a\"iV[\x7Fo\x14\x981\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[a\x06Y\x92\x91a\x16\xBDa\x06+`$a\x16\xDD\x94\x01\x83a$\x8DV[\x94\x90\x93a\x06S``\x89\x01Q\x93\x89Q` \x81Q`\x05\x1B\x91\x01 \x926\x91a(fV[` \x81Q\x91\x01Q\x90_R` Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x80`@_ \x16\x91\x16\x90\x80\x82\x03a\x0B\x9FWPP`\xC0\x84\x01Qa\x17\xB6W[PP`@\x82\x01Q\x91a\x17,\x83aB\xF4V[\x15a\x17\x8AWa\x05\xDD\x7F\x10\xDDR\x8D\xB2\xC4\x9A\xDDeEg\x9B\x97m\xF9\r$\xC05\xD6\xA7[\x17\xF4\x1Bp\x0E\x8C\x18\xCASd\x91\x7F\n-\xC5H\xED\x95\n\xCC\xB4\r]xT\x1F9T\xC5\xE1\x82\xA8\xEC\xF1\x9EX\x1AO\"c\xF6\x1FY\xD2` a\x16z\x96`@Q\x90\x81R\xA1\x93a\x16\x06V[\x82\x7F\xDBx\x8C+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[` \x84\x01Q`\xE0\x85\x01Qa\x01\0\x86\x01Q\x90`@Q\x92a\x17\xD4\x84a\"\xDBV[\x83R` \x83\x01\x90\x80\x82R`@\x84\x01\x92\x83RQ\x92` \x93`@Qa\x17\xF7\x86\x82a#\x14V[_\x81R\x92`@Qa\x18\x08\x87\x82a#\x14V[_\x81R\x94_\x91[\x87\x84\x84\x10a\x1A_WPPPPa\x18Mc\xFF\xFF\xFF\xFF\x82\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x93\x81`\x01\x1B\x91\x80\x83\x04`\x02\x14\x90\x15\x17\x15a\t\xE2W`$\x86a\x18\x98c\xFF\xFF\xFF\xFF`(\x95\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x94Q\x94\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82`@Q\x98\x82\x82\x8B\x01\x9B`\xE0\x1B\x16\x8BR\x80Q\x91\x82\x91\x01\x86\x8B\x01^\x88\x01\x91\x7F\x91\x9E\x13\0\x1C\xD31\x9B\xE5\xA5\xA7\xCB\x18\x92\x03\xBE\x086t\xAC\xB3\xFF\xF2=\x05\xAA\xE9\xC3\xED\x861M\x85\x84\x01R`\xE0\x1B\x16\x93\x84`D\x83\x01R\x80Q\x92\x83\x91\x01`H\x83\x01^\x01\x01\x90`$\x82\x01R\x01\x84\x82Q\x91\x92\x01\x90_[\x86\x82\x82\x10a\x1AKWPPPP\x90a\x19H\x81_\x94\x93\x03`\x1F\x19\x81\x01\x83R\x82a#\x14V[`@Q\x91\x82\x91Q\x80\x91\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xADW_Q\x91`\xA0\x85\x01Q\x15a\x19wW[Pa\x17\x1BV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x80;\x15a\x01&W_\x92a\x19\xF9\x92`@Q\x95\x86\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R```\x04\x86\x01R`d\x85\x01\x91a'ZV[\x90\x7F!;?@\xD7\xC1\x13\xC1\xA0\x12\x07/\xCDy\x1F\xA4K\xF5\x16j#\0\x12\x160\xBD2(\xE2\xB0\x08'`$\x84\x01R`D\x83\x01R\x03\x91Z\xFA\x80\x15a\x02\xADWa\x1A;W[\x80\x80a\x19qV[_a\x1AE\x91a#\x14V[\x82a\x1A4V[\x83Q\x85R\x93\x84\x01\x93\x90\x92\x01\x91`\x01\x01a\x19&V[\x90\x91\x92\x96\x95a\x1Ax\x90\x82\x80a\n.a\n(\x8C\x88Qa&\x91V[\x94\x82Q\x87`\x01\x1B\x90\x88\x82\x04`\x02\x14\x89\x15\x17\x15a\t\xE2Wa\n\x85\x82a\x1A\x9B\x92a&\x91V[\x84Q\x90`\x01\x83\x01\x80\x93\x11a\t\xE2W`\x01\x93`\x04\x8C\x81\x93a\n\xB2a\n\x85\x83\x98a\x1A\xC2\x98a&\x91V[\x96\x01\x91\x90a\x18\x0FV[a\x1A\xD9\x81a\x0B\xDB\x86\x80a#\xB9V[` \x81\x01\x90a\x1A\xE8\x82\x82a#\xB9V[\x80\x91P`\x01\x1B\x81\x81\x04`\x02\x14\x82\x15\x17\x15a\t\xE2Wa\x1B\x05\x90a%\xC5V[\x90_[\x81\x81\x10a\x1F0WPP`\x01`\xFF\x82Qo\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11`\x07\x1Bg\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x82\x1C\x11`\x06\x1B\x17c\xFF\xFF\xFF\xFF\x82\x82\x1C\x11`\x05\x1B\x17a\xFF\xFF\x82\x82\x1C\x11`\x04\x1B\x17\x82\x82\x82\x1C\x11`\x03\x1B\x17`\x0F\x82\x82\x1C\x11`\x02\x1B\x17}\x01\x01\x02\x02\x02\x02\x03\x03\x03\x03\x03\x03\x03\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82\x82\x1C\x1A\x17\x90\x83\x82\x1B\x10\x01\x16\x1Ba\x1B\x9E\x81a%\xC5V[\x91_[\x82\x81\x10a\x1E\xD5WPP[`\x01\x81\x11a\x1E]WPa\x1B\xBD\x90a&\x84V[Q\x91a\x1B\xC9\x81\x83a#\xB9V[\x91\x90P_[\x82\x81\x10a\x1C\x1BWPPP`@`\x01\x93\x92a\x1C\t\x83\x7F\x1C\xC9\xA0u]\xD74\xC1\xEB\xFE\x98\xB6\x8E\xCE \x007\xE3c\xEB6m\r\xEE\x04\xE4 \xE2\xF2<\xC0\x10\x94a#\xB9V[\x83Q\x92\x83R` \x83\x01RP\xA1\x01a\x15\xF3V[a\x1C)\x81a\r1\x84\x87a#\xB9V[\x9Ba\x1C2a%VV[P\x8C``` \x82\x01\x91\x015\x80_R`\x05` R`@_ T\x15a\x0F\xE8WP`\xC0\x82\x01Q\x8E\x91\x88\x91\x15a\x1D\x18W\x83\x82a\x1C\x85a\x1C\x90\x93a\r\xA6`\xE0a\x1C\xA0\x99\x01Q`\x80\x86\x01Q`\x01\x1C\x90a\r\x966\x85a&\xB2V[`@\x86\x015\x90a)\x8CV[\x91`\xA0a\r\xE0a\r\xD5\x8A\x80a#\xB9V[\x9B``\x8D\x01\x80Q`@Q\x92a\x1C\xB4\x84a\"vV[`\xC0\x81\x015\x84R`\xE0` \x85\x01\x91\x015\x81R`@Q\x93a\x1C\xD3\x85a\"vV[_\x85R_` \x86\x01Ra\x1C\xE9\x81Q\x83Q\x90a<\x10V[\x15a\x0EaW\x91a\x1D\n\x91`\x01\x96\x95\x94\x93` \x83Q\x93\x01Q\x90Q\x91Q\x92a<rV[` \x84\x01R\x82RR\x01a\x1B\xCEV[`\xA0\x84\x01Q\x15a\x1D4W[a\x1C\xA0\x93\x82a\x1C\x85a\x1C\x90\x93a\r\xA8V[\x90Pa\x1Dws\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x92\x80a$\x8DV[` _\x81a\x1D\x88a\x0F\r6\x88a&\xB2V[`@Q\x91\x81\x83\x92Q\x91\x82\x91\x01\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xADW_Q\x93\x80;\x15a\x01&W_\x92a\x1D\xF4\x92`@Q\x96\x87\x94\x85\x93\x84\x93\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85R```\x04\x86\x01R`d\x85\x01\x91a'ZV[\x90\x7F\x91\x9E\x13\0\x1C\xD31\x9B\xE5\xA5\xA7\xCB\x18\x92\x03\xBE\x086t\xAC\xB3\xFF\xF2=\x05\xAA\xE9\xC3\xED\x861M`$\x84\x01R`D\x83\x01R\x03\x91Z\xFA\x90\x81\x15a\x02\xADW\x8F\x92\x93\x89a\x1C\x85a\x1C\x90\x93a\x1C\xA0\x97\x83\x96a\x1EMW[P\x93PPP\x93Pa\x1D#V[_a\x1EW\x91a#\x14V[_a\x1EAV[`\x01\x1C_[\x81\x81\x10a\x1EoWPa\x1B\xABV[\x80`\x01\x1B\x90\x7F\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x81\x03a\t\xE2Wa\x1E\xA7\x82\x85a&\x91V[Q\x91`\x01\x81\x01\x80\x91\x11a\t\xE2W`\x01\x92a\x10za\x1E\xC4\x92\x87a&\x91V[a\x1E\xCE\x82\x86a&\x91V[R\x01a\x1EbV[`\x01\x90\x82Q\x81\x10_\x14a\x1E\xFFWa\x1E\xEC\x81\x84a&\x91V[Qa\x1E\xF7\x82\x87a&\x91V[R[\x01a\x1B\xA1V[\x7F\xCC\x1D/\x83\x84E\xDBz\xECC\x1D\xF9\xEE\x8A\x87\x1F@\xE7\xAA^\x06O\xC0Vc>\xF8\xC6\x0F\xAB{\x06a\x1F*\x82\x87a&\x91V[Ra\x1E\xF9V[a\x1F>\x81a\r1\x87\x87a#\xB9V[\x90\x80`\x01\x1B\x81\x81\x04`\x02\x14\x82\x15\x17\x15a\t\xE2W` \x83\x015a\x1F`\x82\x87a&\x91V[R`\x01\x81\x01\x80\x91\x11a\t\xE2Wa\x1F}`\x80`\x01\x94\x015\x91\x86a&\x91V[R\x01a\x1B\x08V[` \x90a\x1F\x8Fa&-V[\x82\x82\x8B\x01\x01R\x01a\x15\xA1V[P_\x94a\x15yV[` \x90`@Qa\x1F\xB2\x81a\"\xBFV[`@Qa\x1F\xBE\x81a\"\xDBV[_\x81R_\x84\x82\x01R_`@\x82\x01R\x81R`@Qa\x1F\xDA\x81a\"vV[_\x81R_\x84\x82\x01R\x83\x82\x01R_`@\x82\x01R_``\x82\x01R\x82\x82\x8A\x01\x01R\x01a\x15hV[_\x93a\x15VV[\x90\x91a \x15\x83a\x0B\xDB\x86\x80a#\xB9V[\x90a &a\x11\xE3` \x84\x01\x84a#\xB9V[\x92\x80\x91P`\x01\x1B\x90\x80\x82\x04`\x02\x14\x90\x15\x17\x15a\t\xE2W\x80\x83\x03a\x12\x1EWP`\x01\x91a P\x91a&\xA5V[\x92\x01\x90a\x14\xFBV[4a\x01&W_`\x03\x196\x01\x12a\x01&Wa pa#7V[_s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81\x16\x83U\x16\x7F\x8B\xE0\x07\x9CS\x16Y\x14\x13D\xCD\x1F\xD0\xA4\xF2\x84\x19I\x7F\x97\"\xA3\xDA\xAF\xE3\xB4\x18okdW\xE0\x82\x80\xA3\0[4a\x01&W_`\x03\x196\x01\x12a\x01&Wa \xECa#7V[a \xF4a#\x83V[a \xFCa#\x83V[t\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF_T\x16\x17_U\x7Fb\xE7\x8C\xEA\x01\xBE\xE3 \xCDNB\x02p\xB5\xEAt\0\r\x11\xB0\xC9\xF7GT\xEB\xDB\xFCTK\x05\xA2X` `@Q3\x81R\xA1\0[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\xFF_T`\xA0\x1C\x16`@Q\x90\x15\x15\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `@Qs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\x04T`@Q\x90\x81R\xF3[4a\x01&W_`\x03\x196\x01\x12a\x01&W` `\x06T`@Q\x90\x81R\xF3[4a\x01&W` `\x03\x196\x01\x12a\x01&W` a\x13o`\x045a%\x11V[4a\x01&W_`\x03\x196\x01\x12a\x01&W\x80\x7F1.0.0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0` \x92R\xF3[\x91\x90\x82\x03\x91\x82\x11a\t\xE2WV[`@\x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a\"\x92W`@RV[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`A`\x04R`$_\xFD[`\x80\x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a\"\x92W`@RV[``\x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a\"\x92W`@RV[a\x01 \x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a\"\x92W`@RV[\x90`\x1F`\x1F\x19\x91\x01\x16\x81\x01\x90\x81\x10g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x17a\"\x92W`@RV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF_T\x163\x03a#WWV[\x7F\x11\x8C\xDA\xA7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R3`\x04R`$_\xFD[`\xFF_T`\xA0\x1C\x16a#\x91WV[\x7F\xD9<\x06e\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04_\xFD[\x905\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE1\x816\x03\x01\x82\x12\x15a\x01&W\x01\x805\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&W` \x01\x91\x81`\x05\x1B6\x03\x83\x13a\x01&WV[\x91\x90\x81\x10\x15a\x13\xEEW`\x05\x1B\x81\x015\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xC1\x816\x03\x01\x82\x12\x15a\x01&W\x01\x90V[\x91\x90\x81\x10\x15a\x13\xEEW`\x05\x1B\x81\x015\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x01\x816\x03\x01\x82\x12\x15a\x01&W\x01\x90V[\x905\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE1\x816\x03\x01\x82\x12\x15a\x01&W\x01\x805\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&W` \x01\x91\x816\x03\x83\x13a\x01&WV[\x90` \x80\x83Q\x92\x83\x81R\x01\x92\x01\x90_[\x81\x81\x10a$\xFBWPPP\x90V[\x82Q\x84R` \x93\x84\x01\x93\x90\x92\x01\x91`\x01\x01a$\xEEV[`\x04T\x81\x10\x15a\x13\xEEW`\x04_R` _ \x01\x90_\x90V[\x80T\x82\x10\x15a\x13\xEEW_R` _ \x01\x90_\x90V[`@Q\x90a%K\x82a\"vV[_` \x83\x82\x81R\x01RV[`@Q\x90a%c\x82a\"\xF7V[``a\x01\0\x83\x82\x81R\x82` \x82\x01R_`@\x82\x01R`@Qa%\x84\x81a\"vV[_\x81R_` \x82\x01R\x83\x82\x01R_`\x80\x82\x01R_`\xA0\x82\x01R_`\xC0\x82\x01R\x82`\xE0\x82\x01R\x01RV[g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\"\x92W`\x05\x1B` \x01\x90V[\x90a%\xCF\x82a%\xADV[a%\xDC`@Q\x91\x82a#\x14V[\x82\x81R`\x1F\x19a%\xEC\x82\x94a%\xADV[\x01\x90` 6\x91\x017V[\x81\x15a&\0W\x04\x90V[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x12`\x04R`$_\xFD[`@Q\x90a&:\x82a\"\xBFV[\x81_\x81R_` \x82\x01R_`@\x82\x01R```@Q\x91a&Y\x83a\"\xBFV[\x81\x83R\x81` \x84\x01R\x81`@\x84\x01R\x81\x80\x84\x01R\x01RV[\x81\x81\x02\x92\x91\x81\x15\x91\x84\x04\x14\x17\x15a\t\xE2WV[\x80Q\x15a\x13\xEEW` \x01\x90V[\x80Q\x82\x10\x15a\x13\xEEW` \x91`\x05\x1B\x01\x01\x90V[\x91\x90\x82\x01\x80\x92\x11a\t\xE2WV[\x80\x92\x91\x03\x91`\xE0\x83\x12a\x01&W`@Q\x90a&\xCC\x82a\"\xBFV[\x81\x93``\x81\x12a\x01&W\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xA0`@\x91\x82Qa'\x05\x81a\"\xDBV[\x845\x81R` \x85\x015` \x82\x01R\x83\x85\x015\x84\x82\x01R\x85R\x01\x12a\x01&W`\xC0``\x91`@Qa'4\x81a\"vV[\x83\x82\x015\x81R`\x80\x82\x015` \x82\x01R` \x85\x01R`\xA0\x81\x015`@\x85\x01R\x015\x91\x01RV[`\x1F\x82` \x94\x93`\x1F\x19\x93\x81\x86R\x86\x86\x017_\x85\x82\x86\x01\x01R\x01\x16\x01\x01\x90V[\x90a'\x94\x90`@\x93\x96\x95\x94\x96``\x84R``\x84\x01\x91a'ZV[\x94` \x82\x01R\x01RV[\x905\x90\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x816\x03\x01\x82\x12\x15a\x01&W\x01\x90V[\x90\x82\x10\x15a\x13\xEEWa'\xE8\x91`\x05\x1B\x81\x01\x90a'\x9EV[\x90V[\x90\x92\x91\x92_[\x81\x81\x10a($W\x84\x7F\x89!\x14t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[\x84a(0\x82\x84\x86a'\xD1V[5\x14a(>W`\x01\x01a'\xF1V[\x91a'\xE8\x93\x94Pa'\xD1V[g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\"\x92W`\x1F\x01`\x1F\x19\x16` \x01\x90V[\x92\x91\x92a(r\x82a(JV[\x91a(\x80`@Q\x93\x84a#\x14V[\x82\x94\x81\x84R\x81\x83\x01\x11a\x01&W\x82\x81` \x93\x84_\x96\x017\x01\x01RV[\x90\x80`\x1F\x83\x01\x12\x15a\x01&W\x81` a'\xE8\x935\x91\x01a(fV[\x90\x80`\x1F\x83\x01\x12\x15a\x01&W\x815\x91a(\xCF\x83a%\xADV[\x92a(\xDD`@Q\x94\x85a#\x14V[\x80\x84R` \x80\x85\x01\x91`\x05\x1B\x83\x01\x01\x91\x83\x83\x11a\x01&W` \x81\x01\x91[\x83\x83\x10a)\tWPPPPP\x90V[\x825g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x82\x01\x90`@`\x1F\x19\x83\x88\x03\x01\x12a\x01&W`@Q\x90a)8\x82a\"vV[` \x83\x015`\x02\x81\x10\x15a\x01&W\x82R`@\x83\x015\x91g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x11a\x01&Wa)o\x88` \x80\x96\x95\x81\x96\x01\x01a(\x9CV[\x83\x82\x01R\x81R\x01\x92\x01\x91a(\xFAV[_\x19\x81\x14a\t\xE2W`\x01\x01\x90V[\x93\x92\x90\x91a)\x98a%VV[P\x81\x94_\x93` \x82\x015\x90\x80\x82\x03a0\xEDWP`\x80\x826\x03\x12a\x01&W`@Q\x93a)\xC2\x85a\"\xBFV[\x825\x94\x85\x81R\x82` \x82\x01R`@\x84\x01\x94\x855g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x85\x01\x90`\x80\x826\x03\x12a\x01&W`@Q\x91a)\xFE\x83a\"\xBFV[\x805g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa*\x1C\x906\x90\x83\x01a(\xB7V[\x83R` \x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa*?\x906\x90\x83\x01a(\xB7V[` \x84\x01R`@\x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa*e\x906\x90\x83\x01a(\xB7V[`@\x84\x01R``\x81\x015\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&Wa*\x8B\x916\x91\x01a(\xB7V[``\x83\x01R`@\x83\x01\x91\x82R``\x86\x01\x92\x835g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa*\xBA\x906\x90\x89\x01a(\x9CV[``\x82\x01Ra*\xC7a&-V[PQ\x91Q\x90`@Q\x92a*\xD9\x84a\"\xBFV[\x83R`\x01` \x84\x01R`@\x83\x01R``\x82\x01R`\xC0\x83\x01Q\x15a/\xFBWa+\x11\x91Pa\x01\0\x83\x01Q`\x80\x84\x01Q\x91a\r\xA0\x83\x83a&\x91V[P[a+*a+ \x85\x85a'\x9EV[`@\x81\x01\x90a#\xB9V[\x90P\x86[\x81\x81\x10a-\xF5WPP\x80` a+g\x92Q\x91\x87a+Q`\x80\x83\x01\x94\x85Q\x90a&\x91V[R\x01Q\x81Q\x91a+`\x83a)~V[\x90Ra&\x91V[Ra+q\x83aC-V[\x15a-\xC9Wa+\x89a+\x83\x83\x83a'\x9EV[\x80a#\xB9V[\x85[\x81\x81\x10a-ZWPPPa+\xACa+\xA2\x83\x83a'\x9EV[` \x81\x01\x90a#\xB9V[\x85[\x81\x81\x10a,\xEBWPPPa+\xC5a+ \x83\x83a'\x9EV[\x85[\x81\x81\x10a,xWPPPa+\xE8\x91a+\xDE\x91a'\x9EV[``\x81\x01\x90a#\xB9V[\x83\x92\x91\x92[\x81\x81\x10a+\xFBWPPPPPV[a,\x06\x81\x83\x86a$\rV[5`\x02\x81\x10\x15a,tW\x90`\x01\x80\x92\x14a,!W[\x01a+\xEDV[\x83\x7F\xA4\x94\xDA\xC4\xB7\x18HCX?\x97.\x06x>,;\xB4\x7FO\x017\xB8\xDFR\xA8`\xDF\x07!\x9F\x8Ca,[a,Q\x84\x87\x8Aa$\rV[` \x81\x01\x90a$\x8DV[\x90a,l`@Q\x92\x83\x92\x87\x84a;\xF9V[\x03\x90\xA2a,\x1BV[\x85\x80\xFD[a,\x83\x81\x83\x85a$\rV[5`\x02\x81\x10\x15a,\xE7W\x90`\x01\x80\x92\x14a,\x9EW[\x01a+\xC7V[\x86\x7F\x9Ca\xB2\x90\xF61\t\x7FV'<\xF4\xDA\xF4\r\xF1\xFF\x9C\xCC3\xF1\x01\xD4d\x83}\xA1\xF5\xAE\x18\xBDYa,\xCEa,Q\x84\x87\x89a$\rV[\x90a,\xDF`@Q\x92\x83\x92\x87\x84a;\xF9V[\x03\x90\xA2a,\x98V[\x87\x80\xFD[a,\xF6\x81\x83\x85a$\rV[5`\x02\x81\x10\x15a,\xE7W\x90`\x01\x80\x92\x14a-\x11W[\x01a+\xAEV[\x86\x7FH$8s\xB4u-\xDC\xB4^\r{\x11\xC4\xC2fX>^\t\x9A\x0By\x8F\xDD\x9C\x1A\xF7\xD4\x93$\xF3a-Aa,Q\x84\x87\x89a$\rV[\x90a-R`@Q\x92\x83\x92\x87\x84a;\xF9V[\x03\x90\xA2a-\x0BV[a-e\x81\x83\x85a$\rV[5`\x02\x81\x10\x15a,\xE7W\x90`\x01\x80\x92\x14a-\x80W[\x01a+\x8BV[\x86\x7F:\x13M\x01\xC0x\x03\0<c0\x17\x17\xDD\xC4a.lG\xAE@\x8E\xEE\xA3\",\xDE\xD52\xD0*\xE6a-\xB0a,Q\x84\x87\x89a$\rV[\x90a-\xC1`@Q\x92\x83\x92\x87\x84a;\xF9V[\x03\x90\xA2a-zV[`$\x84\x84\x7F9\xA9@\xC5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x82R`\x04R\xFD[a.\ta,Q\x82a\x0B\xDBa+ \x8A\x8Aa'\x9EV[\x81\x01\x90``\x81\x83\x03\x12a/\xF7W\x805\x91s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x80\x93\x03a/\xF3W` \x82\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a/\xEFW\x81a.W\x91\x84\x01a(\x9CV[\x91`@\x81\x015\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a/\xE0Wa.x\x92\x91\x01a(\x9CV[\x90`@Q\x91\x7F3\xA8\x92\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83R\x87`\x04\x84\x01R`@`$\x84\x01R\x8B\x83\x80a.\xBD`D\x82\x01\x86a@\0V[\x03\x81\x83\x88Z\xF1\x92\x83\x15a/\xE4W\x8C\x93a/`W[P\x82Q` \x84\x01 \x81Q` \x83\x01 \x03a/%WP`\x01\x93\x92\x91\x7F\xCD\xDB2z\xDB1\xFET7\xDF*\x8Ch0\x1B\xB1:k\xAA\xE42\xA8\x04\x83\x8C\xAA\xF6\x82Pj\xAD\xF1\x91a/\x1C`@Q\x92\x83\x92\x83a@%V[\x03\x90\xA2\x01a+.V[\x90Pa/\\`@Q\x92\x83\x92\x7F\xC5\x04\xFA\xDA\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x84R`\x04\x84\x01a@%V[\x03\x90\xFD[\x90\x92P=\x80\x8D\x83>a/r\x81\x83a#\x14V[\x81\x01\x90` \x81\x83\x03\x12a/\xE0W\x80Q\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a/\xDCW\x01\x81`\x1F\x82\x01\x12\x15a/\xE0W\x80Q\x90a/\xA9\x82a(JV[\x92a/\xB7`@Q\x94\x85a#\x14V[\x82\x84R` \x83\x83\x01\x01\x11a/\xDCW\x81\x8E\x92` \x80\x93\x01\x83\x86\x01^\x83\x01\x01R\x91_a.\xD1V[\x8D\x80\xFD[\x8C\x80\xFD[`@Q=\x8E\x82>=\x90\xFD[\x8B\x80\xFD[\x8A\x80\xFD[\x89\x80\xFD[`\xA0\x83\x01Q\x15a0\rW[PPa+\x13V[a0^\x90` _\x81a0Vs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x96\x8Aa$\x8DV[\x95\x90\x94a9\x83V[`@Q\x91\x81\x83\x92Q\x91\x82\x91\x01\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xADW_Q\x92\x80;\x15a\x01&W_\x92\x86\x92a0\xC3`@Q\x96\x87\x95\x86\x94\x85\x94\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x86R`\x04\x86\x01a'zV[\x03\x91Z\xFA\x80\x15a\x02\xADWa0\xD8W[\x80a0\x06V[a0\xE5\x91\x96P_\x90a#\x14V[_\x94_a0\xD2V[\x7F\x18\xF69\xD8\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$R`D_\xFD[\x93\x92\x90\x91_\x94a1)a%VV[P\x82\x95` \x82\x015\x94\x80\x86\x03a8\xF5WP`\x80\x826\x03\x12a\x01&W`@Q\x94a1Q\x86a\"\xBFV[\x825\x95\x86\x81R\x81` \x82\x01R`@\x84\x01\x94\x855g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&W\x85\x01\x90`\x80\x826\x03\x12a\x01&W`@Q\x91a1\x8D\x83a\"\xBFV[\x805g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa1\xAB\x906\x90\x83\x01a(\xB7V[\x83R` \x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa1\xCE\x906\x90\x83\x01a(\xB7V[` \x84\x01R`@\x81\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa1\xF4\x906\x90\x83\x01a(\xB7V[`@\x84\x01R``\x81\x015\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a\x01&Wa2\x1A\x916\x91\x01a(\xB7V[``\x83\x01R`@\x83\x01\x91\x82R``\x86\x01\x92\x835g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a\x01&Wa2I\x906\x90\x89\x01a(\x9CV[``\x82\x01Ra2Va&-V[PQ\x91Q\x90`@Q\x92a2h\x84a\"\xBFV[\x83R_` \x84\x01R`@\x83\x01R``\x82\x01R`\xC0\x87\x01Q\x15a8\x0BWa2\x9F\x91Pa\x01\0\x87\x01Q`\x80\x88\x01Q\x91a\r\xA0\x83\x83a&\x91V[P[a2\xAEa+ \x85\x85a'\x9EV[\x90P\x82[\x81\x81\x10a6PWPPa2\xE3\x85Q\x87a2\xD1`\x80\x89\x01\x92\x83Q\x90a&\x91V[R` \x87\x01Q\x81Q\x91a+`\x83a)~V[R\x92`\xFF`\x02T\x16\x90`\x01Ta2\xF8\x81a)~V[`\x01U\x91\x86\x92_[\x82\x81\x10a5\xAAWPP`\x01T`\x01`\xFF`\x02T\x16\x1B\x14a5QW[P`@\x01Ra3-a+\x83\x83\x83a'\x9EV[\x90\x84[\x82\x81\x10a4\xE2WPPPa3Ga+\xA2\x83\x83a'\x9EV[\x90\x84[\x82\x81\x10a4sWPPPa3aa+ \x83\x83a'\x9EV[\x90\x84[\x82\x81\x10a4\0WPPPa3{\x91a+\xDE\x91a'\x9EV[\x92\x90\x82[\x84\x81\x10a3\x8DWPPPPPV[a3\x98\x81\x86\x84a$\rV[5`\x02\x81\x10\x15a3\xFCW\x90`\x01\x80\x92\x14a3\xB3W[\x01a3\x7FV[\x83\x7F\xA4\x94\xDA\xC4\xB7\x18HCX?\x97.\x06x>,;\xB4\x7FO\x017\xB8\xDFR\xA8`\xDF\x07!\x9F\x8Ca3\xE3a,Q\x84\x8A\x88a$\rV[\x90a3\xF4`@Q\x92\x83\x92\x87\x84a;\xF9V[\x03\x90\xA2a3\xADV[\x84\x80\xFD[a4\x0B\x81\x84\x84a$\rV[5`\x02\x81\x10\x15a4oW\x90`\x01\x80\x92\x14a4&W[\x01a3dV[\x87\x7F\x9Ca\xB2\x90\xF61\t\x7FV'<\xF4\xDA\xF4\r\xF1\xFF\x9C\xCC3\xF1\x01\xD4d\x83}\xA1\xF5\xAE\x18\xBDYa4Va,Q\x84\x88\x88a$\rV[\x90a4g`@Q\x92\x83\x92\x87\x84a;\xF9V[\x03\x90\xA2a4 V[\x86\x80\xFD[a4~\x81\x84\x84a$\rV[5`\x02\x81\x10\x15a4oW\x90`\x01\x80\x92\x14a4\x99W[\x01a3JV[\x87\x7FH$8s\xB4u-\xDC\xB4^\r{\x11\xC4\xC2fX>^\t\x9A\x0By\x8F\xDD\x9C\x1A\xF7\xD4\x93$\xF3a4\xC9a,Q\x84\x88\x88a$\rV[\x90a4\xDA`@Q\x92\x83\x92\x87\x84a;\xF9V[\x03\x90\xA2a4\x93V[a4\xED\x81\x84\x84a$\rV[5`\x02\x81\x10\x15a4oW\x90`\x01\x80\x92\x14a5\x08W[\x01a30V[\x87\x7F:\x13M\x01\xC0x\x03\0<c0\x17\x17\xDD\xC4a.lG\xAE@\x8E\xEE\xA3\",\xDE\xD52\xD0*\xE6a58a,Q\x84\x88\x88a$\rV[\x90a5I`@Q\x92\x83\x92\x87\x84a;\xF9V[\x03\x90\xA2a5\x02V[\x90\x91`\x02T\x90h\x01\0\0\0\0\0\0\0\0\x82\x10\x15a\"\x92W`@\x92a5\x80\x83`\x01a5\xA3\x95\x01`\x02U`\x02a%)V[\x81T\x90`\x03\x1B\x90_\x19\x85\x83\x1B\x92\x1B\x19\x16\x17\x90U`\x03_R` _ \x01T\x90a>IV[\x91\x90a3\x1BV[\x90\x93`\x01\x90\x81\x86\x16a6\x18W\x7F@W\x87\xFA\x12\xA8#\xE0\xF2\xB7c\x1C\xC4\x1B;\xA8\x82\x8B3!\xCA\x81\x11\x11\xFAu\xCD:\xA3\xBBZ\xCE\x83\x01\x81\x90U`\x03_R\x7F\xC2WZ\x0E\x9EY<\0\xF9Y\xF8\xC9/\x12\xDB(i\xC39Z;\x05\x02\xD0^%\x16Doq\xF8[\x83\x01Ta6\r\x91a>IV[\x94[\x81\x1C\x91\x01a3\0V[`\x02_R\x7F@W\x87\xFA\x12\xA8#\xE0\xF2\xB7c\x1C\xC4\x1B;\xA8\x82\x8B3!\xCA\x81\x11\x11\xFAu\xCD:\xA3\xBBZ\xCE\x83\x01Ta6J\x91\x90a>IV[\x94a6\x0FV[a6da,Q\x82a\x0B\xDBa+ \x8A\x8Aa'\x9EV[\x81\x01\x90``\x81\x83\x03\x12a,tW\x805\x91s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x80\x93\x03a4oW` \x82\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11a,\xE7W\x81a6\xB2\x91\x84\x01a(\x9CV[\x91`@\x81\x015\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a7\xFCWa6\xD3\x92\x91\x01a(\x9CV[\x90`@Q\x91\x7F3\xA8\x92\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83R\x86`\x04\x84\x01R`@`$\x84\x01R\x87\x83\x80a7\x18`D\x82\x01\x86a@\0V[\x03\x81\x83\x88Z\xF1\x92\x83\x15a8\0W\x88\x93a7\x80W[P\x82Q` \x84\x01 \x81Q` \x83\x01 \x03a/%WP`\x01\x93\x92\x91\x7F\xCD\xDB2z\xDB1\xFET7\xDF*\x8Ch0\x1B\xB1:k\xAA\xE42\xA8\x04\x83\x8C\xAA\xF6\x82Pj\xAD\xF1\x91a7w`@Q\x92\x83\x92\x83a@%V[\x03\x90\xA2\x01a2\xB2V[\x90\x92P=\x80\x89\x83>a7\x92\x81\x83a#\x14V[\x81\x01\x90` \x81\x83\x03\x12a7\xFCW\x80Q\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11a/\xF7W\x01\x81`\x1F\x82\x01\x12\x15a7\xFCW\x80Q\x90a7\xC9\x82a(JV[\x92a7\xD7`@Q\x94\x85a#\x14V[\x82\x84R` \x83\x83\x01\x01\x11a/\xF7W\x81\x8A\x92` \x80\x93\x01\x83\x86\x01^\x83\x01\x01R\x91_a7,V[\x88\x80\xFD[`@Q=\x8A\x82>=\x90\xFD[`\xA0\x87\x01Q\x15a8\x1DW[PPa2\xA1V[a8f\x90` _\x81a0Vs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x96\x8Aa$\x8DV[`@Q\x91\x81\x83\x92Q\x91\x82\x91\x01\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xADW_Q\x92\x80;\x15a\x01&W_\x92\x85\x92a8\xCB`@Q\x96\x87\x95\x86\x94\x85\x94\x7F\xABu\x0Eu\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x86R`\x04\x86\x01a'zV[\x03\x91Z\xFA\x80\x15a\x02\xADWa8\xE0W[\x80a8\x16V[a8\xED\x91\x92P_\x90a#\x14V[_\x90_a8\xDAV[\x85\x90\x7F\x18\xF69\xD8\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$R`D_\xFD[\x80Q\x80Q\x91`@` \x83\x01Q\x92\x01Q` \x82\x01Q` \x81Q\x91\x01Q\x91```@\x85\x01Q\x94\x01Q\x94`@Q\x96` \x88\x01R`@\x87\x01R``\x86\x01R`\x80\x85\x01R`\xA0\x84\x01R`\xC0\x83\x01R`\xE0\x82\x01R`\xE0\x81Ra'\xE8a\x01\0\x82a#\x14V[``\x81\x01Q\x81Q` \x83\x01Q\x90\x91\x90\x15a;\xF0W`@c\x01\0\0\0\x93[\x01Q\x90\x80Q\x90\x81Qc\xFF\xFF\xFF\xFF\x16a9\xDA\x90b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x91a9\xE4\x90a>\x8CV[` \x82\x01Q\x80Qc\xFF\xFF\xFF\xFF\x16a:\x1D\x90b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x90a:'\x90a>\x8CV[\x90`@\x84\x01Q\x92\x83Qc\xFF\xFF\xFF\xFF\x16a:b\x90b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x93a:l\x90a>\x8CV[\x94``\x01Q\x95\x86Qc\xFF\xFF\xFF\xFF\x16a:\xA6\x90b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x96a:\xB0\x90a>\x8CV[\x97`@Q\x9A\x8B\x9A` \x8C\x01R`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`@\x8B\x01R`D\x8A\x01R`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`d\x89\x01R\x80Q` \x81\x92\x01`h\x8A\x01^\x87\x01\x90`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`h\x82\x01R\x81Q` \x81\x93\x01`l\x83\x01^\x01`h\x01\x90`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`\x04\x82\x01R\x81Q` \x81\x93\x01`\x08\x83\x01^\x01`\x04\x01\x90`\xE0\x1B\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16`\x04\x82\x01R\x81Q` \x81\x93\x01`\x08\x83\x01^\x01`\x04\x01`\x04\x81\x01_\x90R\x03`\x04\x01`\x1F\x19\x81\x01\x82Ra'\xE8\x90\x82a#\x14V[`@_\x93a9\xA0V[`@\x90a'\xE8\x94\x92\x81R\x81` \x82\x01R\x01\x91a'ZV[\x80\x15\x80\x15a<bW[\x80\x15a<ZW[\x80\x15a<JW[a<DWd\x01\0\0\x03\xD0\x19`\x07\x81\x80\x93\x81\x81\x80\t\t\x08\x91\x80\t\x14\x90V[PP_\x90V[Pd\x01\0\0\x03\xD0\x19\x82\x10\x15a<'V[P\x81\x15a< V[Pd\x01\0\0\x03\xD0\x19\x81\x10\x15a<\x19V[\x92\x93\x92\x90\x91_\x90\x80\x83\x03a>,WPPd\x01\0\0\x03\xD0\x19_\x94\x83\x08a<\x9BWPP\x90P_\x90_\x90V[_a<\xAD\x92d\x01\0\0\x03\xD0\x19\x92aB}V[\x93\x90\x91\x90[\x84\x15\x15\x85\x81a>\x1BW[P\x80a>\x13W[\x15a=\xB5W\x80\x94\x80`\x01d\x01\0\0\x03\xD0\x19\x84\x92[a=+WPPPP\x80a<\xFEWP\x90d\x01\0\0\x03\xD0\x19\x80\x92\x81\x80\x87\x80\t\x80\x92\t\x95\t\x90\t\x90V[\x80\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`$\x92R`\x12`\x04R\xFD[a=9\x84\x82\x9A\x94\x95\x9Aa%\xF6V[\x91\x80\x94a=\x88Wd\x01\0\0\x03\xD0\x19\x90\x83\td\x01\0\0\x03\xD0\x19\x03\x90d\x01\0\0\x03\xD0\x19\x82\x11a\t\xE2Wa=zd\x01\0\0\x03\xD0\x19a=\x80\x93\x88\x96\x08\x95\x9A\x80\x94a&qV[\x90a\"iV[\x92\x90\x83a<\xD7V[`$\x86\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x12`\x04R\xFD[`d`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x0E`$\x82\x01R\x7FInvalid number\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R\xFD[P`\x01a<\xC3V[d\x01\0\0\x03\xD0\x19\x91P\x14\x15_a<\xBCV[a>@\x93d\x01\0\0\x03\xD0\x19\x93\x96\x92\x96a@\x82V[\x93\x90\x91\x90a<\xB2V[_\x90` \x92`@Q\x90\x84\x82\x01\x92\x83R`@\x82\x01R`@\x81Ra>l``\x82a#\x14V[`@Q\x91\x82\x91Q\x80\x91\x83^\x81\x01\x83\x81R\x03\x90`\x02Z\xFA\x15a\x02\xADW_Q\x90V[\x80Q``\x92\x91_\x91[\x80\x83\x10a>\xA1WPPPV[\x90\x91\x93a>\xE8c\xFF\xFF\xFF\xFF` a>\xB8\x88\x87a&\x91V[Q\x01QQ`\x02\x1C\x16b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x90` a>\xF5\x87\x86a&\x91V[Q\x01Qa?\x02\x87\x86a&\x91V[QQ`\x02\x81\x10\x15a?\xD3W`\x04` \x93a?\xCA\x93\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x86\x80`\x01\x99a?i\x87\x98b\xFF\0\xFFc\xFF\0\xFF\0\x82`\x08\x1B\x16\x91`\x08\x1C\x16\x17c\xFF\xFF\xFF\xFF\x80\x82`\x10\x1B\x16\x91`\x10\x1C\x16\x17\x90V[\x94\x84`@Q\x9B\x88\x8D\x99Q\x91\x82\x91\x01\x86\x8B\x01^\x88\x01\x92`\xE0\x1B\x16\x83\x83\x01R\x80Q\x92\x83\x91\x01`$\x83\x01^\x01\x01\x91`\xE0\x1B\x16\x83\x82\x01R\x03\x01\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE4\x81\x01\x84R\x01\x82a#\x14V[\x94\x01\x91\x90a>\x95V[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`!`\x04R`$_\xFD[\x90`\x1F\x19`\x1F` \x80\x94\x80Q\x91\x82\x91\x82\x87R\x01\x86\x86\x01^_\x85\x82\x86\x01\x01R\x01\x16\x01\x01\x90V[\x90\x91a@<a'\xE8\x93`@\x84R`@\x84\x01\x90a@\0V[\x91` \x81\x84\x03\x91\x01Ra@\0V[\x80Th\x01\0\0\0\0\0\0\0\0\x81\x10\x15a\"\x92Wa@l\x91`\x01\x82\x01\x81Ua%)V[_\x19\x82\x93\x92T\x91`\x03\x1B\x92\x83\x1B\x92\x1B\x19\x16\x17\x90UV[\x94\x92\x91\x85\x15\x80aBuW[aBiW\x80\x15\x80aBaW[aBWW`@Q`\x80\x91a@\xAD\x83\x83a#\x14V[\x826\x837\x86\x15a&\0W\x86\x94\x85\x80\x92\x81\x80`\x01\x80\t\x80\x87R\x97\x81\x89`\x01\t\x9C` \x88\x01\x9D\x8ER\x82`@\x89\x01\x9D\x8E\x8C\x81RQ`\x01\t\x91``\x8A\x01\x92\x83R`@Q\x9E\x8Fa@\xF7\x90a\"\xBFV[Q\x90\t\x8DRQ\x90\t\x94` \x8B\x01\x95\x86RQ\x90\t\x98`@\x89\x01\x99\x8ARQ\x90\t``\x87\x01\x90\x81R\x86Q\x88Q\x14\x80\x15\x90aBKW[\x15aA\xEDW\x84\x92\x83\x80\x80\x93\x81`@Q\x9C\x85aAE\x8F\x97\x88a#\x14V[6\x877Q\x8CQaAU\x90\x83a\"iV[\x90\x08\x84RQ\x85QaAf\x90\x83a\"iV[\x90\x08\x98` \x83\x01\x99\x8AR\x81\x80\x8B\x81\x80\x80\x80\x89Q\x8AQ\x90\t\x93`@\x8A\x01\x94\x85R\x81\x85Q\x8BQ\x90\t``\x90\x9A\x01\x99\x8ARQ\x80\t\x88QaA\xA3\x90\x83a\"iV[\x90\x08\x81\x80\x87Q\x85Q\x90\t`\x02\taA\xBA\x90\x83a\"iV[\x90\x08\x9CQ\x93Q\x90Q\x90\taA\xCE\x8C\x83a\"iV[\x90\x08\x90\t\x92Q\x90Q\x90\taA\xE2\x90\x83a\"iV[\x90\x08\x94Q\t\x91\x92\x91\x90V[`d`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x1E`$\x82\x01R\x7FUse jacDouble function instead\0\0`D\x82\x01R\xFD[P\x81Q\x81Q\x14\x15aA)V[P\x92P`\x01\x91\x90PV[P\x82\x15a@\x99V[\x94P\x90\x92P`\x01\x91\x90PV[P\x81\x15a@\x8DV[\x93\x91\x92\x90\x92\x81\x15a&\0W`\x01\x82\x80aB\xEA\x81\x80\x80\x80\x97\x81\x80aB\xDA\x9E\x81\x8F\x81\x81\x81\x92\t\x9A\x8B\x96\x81\x8F\x81\x80\x82\x81\x93\t\x9A\x88\t`\x04\t\x98\x80\t\x90\t\x92\x80\t`\x03\t\x08\x91\x81aB\xCD\x81\x83\x80\x08\x82a\"iV[\x81\x85\x80\t\x08\x9E\x8F\x83a\"iV[\x90\x08\x90\t\x93\x80\t`\x08\t\x83a\"iV[\x90\x08\x94\t`\x02\t\x90V[\x80_R`\x05` R`@_ T\x15_\x14aC(WaC\x13\x81`\x04a@JV[`\x04T\x90_R`\x05` R`@_ U`\x01\x90V[P_\x90V[\x80_R`\x07` R`@_ T\x15_\x14aC(WaCL\x81`\x06a@JV[`\x06T\x90_R`\x07` R`@_ U`\x01\x90V[`\x04\x11\x15a?\xD3WV[\x81Q\x91\x90`A\x83\x03aC\x9BWaC\x94\x92P` \x82\x01Q\x90```@\x84\x01Q\x93\x01Q_\x1A\x90aDlV[\x91\x92\x90\x91\x90V[PP_\x91`\x02\x91\x90V[aC\xAE\x81aCaV[\x80aC\xB7WPPV[aC\xC0\x81aCaV[`\x01\x81\x03aC\xF0W\x7F\xF6E\xEE\xDF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04_\xFD[aC\xF9\x81aCaV[`\x02\x81\x03aD-WP\x7F\xFC\xE6\x98\xF7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[`\x03\x90aD9\x81aCaV[\x14aDAWPV[\x7F\xD7\x8B\xCE\x0C\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_R`\x04R`$_\xFD[\x91\x90\x7F\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF]WnsW\xA4P\x1D\xDF\xE9/Fh\x1B \xA0\x84\x11aD\xF0W\x91` \x93`\x80\x92`\xFF_\x95`@Q\x94\x85R\x16\x86\x84\x01R`@\x83\x01R``\x82\x01R\x82\x80R`\x01Z\xFA\x15a\x02\xADW_Qs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x15aD\xE6W\x90_\x90_\x90V[P_\x90`\x01\x90_\x90V[PPP_\x91`\x03\x91\x90V",
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
        const COUNT: usize = 20usize;
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
